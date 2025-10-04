#!/usr/bin/env python3

import matplotlib
matplotlib.use('Agg')  # Use non-interactive backend
import matplotlib.pyplot as plt
import numpy as np
import re
import os
from pathlib import Path

class SimulationAnalyzer:
    def __init__(self, results_dir):
        self.results_dir = Path(results_dir)
        self.rtl_results = {}
        self.gem5_results = {}
        
    def parse_rtl_logs(self, log_dir):
        """Parse RTL simulation logs to extract cycles/second"""
        cycles_per_second = []
        
        for log_file in Path(log_dir).glob("**/*.log"):
            try:
                with open(log_file, 'r') as f:
                    content = f.read()
                    # Look for cycles/second pattern
                    matches = re.findall(r'(\d+\.?\d*)\s*cycles/second', content, re.IGNORECASE)
                    for match in matches:
                        cycles_per_second.append(float(match))
            except Exception as e:
                print(f"Error parsing {log_file}: {e}")
                
        return cycles_per_second
    
    def parse_gem5_stats(self, stats_file):
        """Parse GEM5 stats.txt file to extract CPI and hostTickRate"""
        cpi = None
        host_tick_rate = None
        
        try:
            with open(stats_file, 'r') as f:
                for line in f:
                    if 'cpi' in line.lower() and '=' in line:
                        cpi = float(line.split('=')[1].strip())
                    elif 'hosttickrate' in line.lower() and '=' in line:
                        host_tick_rate = float(line.split('=')[1].strip())
        except Exception as e:
            print(f"Error parsing {stats_file}: {e}")
            
        return cpi, host_tick_rate
    
    def collect_rtl_results(self):
        """Collect RTL simulation results"""
        processors = ['Piccolo', 'Flute', 'Toooba']
        simulators = ['verilator', 'bluesim']
        
        for processor in processors:
            self.rtl_results[processor] = {}
            for simulator in simulators:
                # Look for log directories with more flexible patterns
                log_patterns = [
                    f"{processor}/builds/*{simulator}*/Logs",
                    f"*{processor}*{simulator}*/Logs",
                    f"{processor}/builds/*/Logs"
                ]
                
                cycles_data = []
                for pattern in log_patterns:
                    try:
                        for log_dir in self.results_dir.glob(pattern):
                            if log_dir.exists():
                                cycles_data.extend(self.parse_rtl_logs(log_dir))
                    except Exception as e:
                        print(f"Error processing pattern {pattern}: {e}")
                
                if cycles_data:
                    self.rtl_results[processor][simulator] = {
                        'cycles_per_second': cycles_data,
                        'avg_cycles_per_second': np.mean(cycles_data),
                        'max_cycles_per_second': np.max(cycles_data)
                    }
    
    def collect_gem5_results(self):
        """Collect GEM5 simulation results"""
        # Look for GEM5 results directories
        for config_dir in self.results_dir.glob("results/*"):
            if config_dir.is_dir():
                config_name = config_dir.name
                self.gem5_results[config_name] = {}
                
                # Look for stats.txt files
                for stats_file in config_dir.glob("**/stats.txt"):
                    benchmark = stats_file.parent.parent.name
                    cpi, host_tick_rate = self.parse_gem5_stats(stats_file)
                    
                    if cpi is not None:
                        self.gem5_results[config_name][benchmark] = {
                            'cpi': cpi,
                            'host_tick_rate': host_tick_rate
                        }
    
    def plot_rtl_performance(self):
        """Create plots for RTL simulation performance"""
        fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(15, 6))
        
        processors = list(self.rtl_results.keys())
        verilator_perf = []
        bluesim_perf = []
        
        for processor in processors:
            if 'verilator' in self.rtl_results[processor]:
                verilator_perf.append(self.rtl_results[processor]['verilator']['avg_cycles_per_second'])
            else:
                verilator_perf.append(0)
                
            if 'bluesim' in self.rtl_results[processor]:
                bluesim_perf.append(self.rtl_results[processor]['bluesim']['avg_cycles_per_second'])
            else:
                bluesim_perf.append(0)
        
        x = np.arange(len(processors))
        width = 0.35
        
        ax1.bar(x - width/2, verilator_perf, width, label='Verilator', alpha=0.8)
        ax1.bar(x + width/2, bluesim_perf, width, label='Bluesim', alpha=0.8)
        ax1.set_xlabel('Processor')
        ax1.set_ylabel('Cycles/Second')
        ax1.set_title('RTL Simulation Performance Comparison')
        ax1.set_xticks(x)
        ax1.set_xticklabels(processors)
        ax1.legend()
        ax1.grid(True, alpha=0.3)
        
        # Performance ratio plot
        ratios = []
        labels = []
        for i, processor in enumerate(processors):
            if verilator_perf[i] > 0 and bluesim_perf[i] > 0:
                ratio = verilator_perf[i] / bluesim_perf[i]
                ratios.append(ratio)
                labels.append(processor)
        
        if ratios:
            ax2.bar(labels, ratios, alpha=0.8, color='orange')
            ax2.axhline(y=1, color='red', linestyle='--', alpha=0.7, label='Equal Performance')
            ax2.set_xlabel('Processor')
            ax2.set_ylabel('Verilator/Bluesim Speed Ratio')
            ax2.set_title('Simulator Speed Comparison')
            ax2.legend()
            ax2.grid(True, alpha=0.3)
        
        plt.tight_layout()
        plt.savefig('rtl_performance_comparison.png', dpi=300, bbox_inches='tight')
        plt.show()
    
    def plot_gem5_performance(self):
        """Create plots for GEM5 simulation performance"""
        if not self.gem5_results:
            print("No GEM5 results found")
            return
            
        configs = list(self.gem5_results.keys())
        benchmarks = set()
        for config in configs:
            benchmarks.update(self.gem5_results[config].keys())
        benchmarks = list(benchmarks)
        
        fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(15, 6))
        
        # CPI comparison
        for benchmark in benchmarks:
            cpi_values = []
            config_labels = []
            for config in configs:
                if benchmark in self.gem5_results[config]:
                    cpi_values.append(self.gem5_results[config][benchmark]['cpi'])
                    config_labels.append(config)
            
            if cpi_values:
                ax1.plot(config_labels, cpi_values, marker='o', label=benchmark)
        
        ax1.set_xlabel('Configuration')
        ax1.set_ylabel('CPI (Cycles Per Instruction)')
        ax1.set_title('GEM5 O3 Performance: CPI vs Configuration')
        ax1.legend()
        ax1.grid(True, alpha=0.3)
        plt.setp(ax1.get_xticklabels(), rotation=45, ha='right')
        
        # Host Tick Rate comparison
        for benchmark in benchmarks:
            htr_values = []
            config_labels = []
            for config in configs:
                if benchmark in self.gem5_results[config]:
                    htr = self.gem5_results[config][benchmark]['host_tick_rate']
                    if htr is not None:
                        htr_values.append(htr)
                        config_labels.append(config)
            
            if htr_values:
                ax2.plot(config_labels, htr_values, marker='s', label=benchmark)
        
        ax2.set_xlabel('Configuration')
        ax2.set_ylabel('Host Tick Rate')
        ax2.set_title('GEM5 O3 Performance: Host Tick Rate vs Configuration')
        ax2.legend()
        ax2.grid(True, alpha=0.3)
        plt.setp(ax2.get_xticklabels(), rotation=45, ha='right')
        
        plt.tight_layout()
        plt.savefig('gem5_performance_comparison.png', dpi=300, bbox_inches='tight')
        plt.show()
    
    def generate_summary_table(self):
        """Generate summary tables for the report"""
        print("\n=== RTL Simulation Results Summary ===")
        print(f"{'Processor':<12} {'Verilator (cycles/s)':<20} {'Bluesim (cycles/s)':<20} {'Speed Ratio':<12}")
        print("-" * 70)
        
        for processor in self.rtl_results:
            verilator_perf = self.rtl_results[processor].get('verilator', {}).get('avg_cycles_per_second', 0)
            bluesim_perf = self.rtl_results[processor].get('bluesim', {}).get('avg_cycles_per_second', 0)
            
            if verilator_perf > 0 and bluesim_perf > 0:
                ratio = verilator_perf / bluesim_perf
                print(f"{processor:<12} {verilator_perf:<20.2e} {bluesim_perf:<20.2e} {ratio:<12.2f}")
            else:
                print(f"{processor:<12} {verilator_perf:<20.2e} {bluesim_perf:<20.2e} {'N/A':<12}")
        
        print("\n=== GEM5 Simulation Results Summary ===")
        for config in self.gem5_results:
            print(f"\nConfiguration: {config}")
            print(f"{'Benchmark':<15} {'CPI':<10} {'Host Tick Rate':<15}")
            print("-" * 40)
            for benchmark in self.gem5_results[config]:
                cpi = self.gem5_results[config][benchmark]['cpi']
                htr = self.gem5_results[config][benchmark]['host_tick_rate']
                htr_str = f"{htr:.2e}" if htr is not None else "N/A"
                print(f"{benchmark:<15} {cpi:<10.3f} {htr_str:<15}")
    
    def run_analysis(self):
        """Run complete analysis"""
        print("Collecting RTL results...")
        self.collect_rtl_results()
        
        print("Collecting GEM5 results...")
        self.collect_gem5_results()
        
        print("Generating plots...")
        self.plot_rtl_performance()
        self.plot_gem5_performance()
        
        print("Generating summary...")
        self.generate_summary_table()

if __name__ == "__main__":
    # Usage example
    analyzer = SimulationAnalyzer("/export/scratch/users/hasan181")
    analyzer.run_analysis()