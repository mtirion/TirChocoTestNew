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

            var assembly = Assembly.GetEntryAssembly();
            var assemblyName = assembly.GetName().Name;
            var gitVersionInformationType = assembly.GetType("GitVersionInformation");
            Console.WriteLine($"SemVer: {gitVersionInformationType.GetField("SemVer").GetValue(null)}");

            Console.WriteLine("");

            var fields = gitVersionInformationType.GetFields();

            foreach (var field in fields)
            {
                Console.WriteLine(string.Format("{0}: {1}", field.Name, field.GetValue(null)));
            }

            // The GitVersionInformation class generated from a F# project exposes properties
            var properties = gitVersionInformationType.GetProperties();

            foreach (var property in properties)
            {
                Console.WriteLine(string.Format("{0}: {1}", property.Name, property.GetGetMethod(true).Invoke(null, null)));
            }
        }
    }
}
