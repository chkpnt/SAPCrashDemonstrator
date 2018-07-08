# App is crashing due to failed initialization of MAFLogonCore in SMP SDK 3.0 SP16 PL13

This repository is intended to demonstrate the crash reported to SAP as incident _293402 / 2018 App is crashing due to failed initialization of MAFLogonCore in SMP SDK 3.0 SP16 PL13_.

To compile this project, you have to adapt the `Podfile` appropriately and call `pod update`.

*Update, 29.07.2018: SAP has found the cause for this bug. A fix is expected for SMP SDK 3.0 SP16 PL15.*

# Step-by-step introductions on how to reproduce the issue

1. Setup the project to use an older SDK (I've used SMP SDK 3.0 SP16 PL6).
2. Adpot `ViewController.swift` so that your SMP-Server is used for registration.
3. Start the app, register and persist the registration
4. Update the project to use SMP SDK 3.0 SP16 PL13
5. Either the app is crashing or it has lost the registration informations
6. Remove the app
7. After reinstallation, the app is crashing again with a `DataVaultException`

# Crash report
```
2018-06-07 18:44:13.785878+0200 SAPCrashDemonstrator[40129:679081] The following DataVault IDs are found: com.sap.MAFLogonManagerNG, MAFLogonCore_de.andrena.SAPCrashDemonstrator
2018-06-07 18:44:20.560735+0200 SAPCrashDemonstrator[40129:679081] The registration is lost if it was made with a previous SDK.
2018-06-07 18:44:20.560948+0200 SAPCrashDemonstrator[40129:679081] The app crashes, if the app is reinstalled afterwards.
2018-06-07 18:44:20.561882+0200 SAPCrashDemonstrator[40129:679081] [libraryName: Supportability] [version: 3.16.10] [buildTime: Fri May 11 14:49:53 CEST 2018] [gitCommit: b7802e153e2174b36d587866770f1ca977782f5f] [gitBranch: origin/fa/rel-3.16]
2018-06-07 18:44:20.562288+0200 SAPCrashDemonstrator[40129:679081] [libraryName: ClientLog] [version: 3.16.10] [buildTime: Fri May 11 14:49:21 CEST 2018] [gitCommit: b7802e153e2174b36d587866770f1ca977782f5f] [gitBranch: origin/fa/rel-3.16]
2018-06-07 18:44:20.562893+0200 SAPCrashDemonstrator[40129:679081] [libraryName: E2ETrace2] [version: 3.16.10] [buildTime: Fri May 11 14:48:41 CEST 2018] [gitCommit: b7802e153e2174b36d587866770f1ca977782f5f] [gitBranch: origin/fa/rel-3.16]
2018-06-07 18:44:20.675644+0200 SAPCrashDemonstrator[40129:679081] *** Terminating app due to uncaught exception 'DataVaultException', reason: 'Does Not Exist'
*** First throw call stack:
(
	0   CoreFoundation                      0x0000000103c591e6 __exceptionPreprocess + 294
	1   libobjc.A.dylib                     0x0000000105067031 objc_exception_throw + 48
	2   SAPCrashDemonstrator                0x0000000101c0bfc0 +[DataVault raiseException:message:] + 80
	3   SAPCrashDemonstrator                0x0000000101c07df4 -[DataVault initWithId:expectedToExist:initialPassword:initialSalt:] + 460
	4   SAPCrashDemonstrator                0x0000000101c0c048 +[DataVault doGetVault:] + 116
	5   SAPCrashDemonstrator                0x0000000101c09e1a __25+[DataVault deleteVault:]_block_invoke + 38
	6   SAPCrashDemonstrator                0x0000000101c0c11e ___ZL21rethrowing_dispatcherPFvPU28objcproto17OS_dispatch_queue8NSObjectU13block_pointerFvvEES1_S3__block_invoke + 16
	7   libdispatch.dylib                   0x0000000108c7f7ec _dispatch_client_callout + 8
	8   libdispatch.dylib                   0x0000000108c8655c _dispatch_queue_barrier_sync_invoke_and_complete + 374
	9   SAPCrashDemonstrator                0x0000000101c0838d _ZL21rethrowing_dispatcherPFvPU28objcproto17OS_dispatch_queue8NSObjectU13block_pointerFvvEES1_S3_ + 185
	10  SAPCrashDemonstrator                0x0000000101c09db6 +[DataVault deleteVault:] + 118
	11  SAPCrashDemonstrator                0x0000000101caa894 -[MAFLogonCore cleanUpUserDataVaults] + 1387
	12  SAPCrashDemonstrator                0x0000000101c9a7fa -[MAFLogonCore initWithApplicationId:multiUserSupport:dataVault:] + 1049
	13  SAPCrashDemonstrator                0x0000000101bade22 _T0So12MAFLogonCoreCSQyABGSQySSG13applicationId_tcfcTO + 146
	14  SAPCrashDemonstrator                0x0000000101baaddb _T0So12MAFLogonCoreCSQyABGSQySSG13applicationId_tcfC + 75
	15  SAPCrashDemonstrator                0x0000000101bab3b4 _T020SAPCrashDemonstrator14ViewControllerC18didTapInitMAFLogonyypF + 436
	16  SAPCrashDemonstrator                0x0000000101bab6ec _T020SAPCrashDemonstrator14ViewControllerC18didTapInitMAFLogonyypFTo + 76
	17  UIKit                               0x00000001060193e8 -[UIApplication sendAction:to:from:forEvent:] + 83
	18  UIKit                               0x00000001061947a4 -[UIControl sendAction:to:forEvent:] + 67
	19  UIKit                               0x0000000106194ac1 -[UIControl _sendActionsForEvents:withEvent:] + 450
	20  UIKit                               0x0000000106193a09 -[UIControl touchesEnded:withEvent:] + 580
	21  UIKit                               0x000000010608e0bf -[UIWindow _sendTouchesForEvent:] + 2729
	22  UIKit                               0x000000010608f7c1 -[UIWindow sendEvent:] + 4086
	23  UIKit                               0x0000000106033310 -[UIApplication sendEvent:] + 352
	24  UIKit                               0x00000001069746af __dispatchPreprocessedEventFromEventQueue + 2796
	25  UIKit                               0x00000001069772c4 __handleEventQueueInternal + 5949
	26  CoreFoundation                      0x0000000103bfbbb1 __CFRUNLOOP_IS_CALLING_OUT_TO_A_SOURCE0_PERFORM_FUNCTION__ + 17
	27  CoreFoundation                      0x0000000103be04af __CFRunLoopDoSources0 + 271
	28  CoreFoundation                      0x0000000103bdfa6f __CFRunLoopRun + 1263
	29  CoreFoundation                      0x0000000103bdf30b CFRunLoopRunSpecific + 635
	30  GraphicsServices                    0x000000010b1d4a73 GSEventRunModal + 62
	31  UIKit                               0x0000000106018057 UIApplicationMain + 159
	32  SAPCrashDemonstrator                0x0000000101bb1227 main + 55
	33  libdyld.dylib                       0x0000000108cfc955 start + 1
)
libc++abi.dylib: terminating with uncaught exception of type DataVaultException
```
