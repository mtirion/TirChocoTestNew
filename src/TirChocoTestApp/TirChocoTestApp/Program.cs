using System;
using System.Reflection;

namespace TirChocoTestApp
{
    /// <summary>
    /// The program class.
    /// </summary>
    class Program
    {
        /// <summary>
        /// Main entry point.
        /// </summary>
        /// <param name="args">Command line arguments.</param>
        static void Main(string[] args)
        {
            Console.WriteLine("This is a test application.\n");

            Console.WriteLine($"Main (File) Version: {Assembly.GetEntryAssembly().GetCustomAttribute<AssemblyFileVersionAttribute>().Version}");
            Console.WriteLine($"Assembly Version: {Assembly.GetEntryAssembly().GetName().Version}");
            Console.WriteLine($"Product (Info) Version: {Assembly.GetEntryAssembly().GetCustomAttribute<AssemblyInformationalVersionAttribute>().InformationalVersion}");
        }
    }
}
