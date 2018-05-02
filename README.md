# Crash with SMP SDK 3.0 SP16 PL10 

This repository is intended to demonstrate the crash with the fix (SMP SDK 3.0 SP16 PL10) to the bug reported to SAP as incident _98189 / 2018 Memory Leak in lodata::ModificationLogEntityEntry_. The same app with SMP SDK 3.0 SP16 PL06 does not crash.

To compile this project, you have to adapt the `Podfile` appropriately and call `pod update`.

[Crash report](SAPCrashDemonstrator_2018-05-02-193248_asiago.crash)
