package tasks

import (
	"fmt"
	"os/exec"
	"setup/taskr"
)

func setupOs(t *taskr.Task) {
	t.SubTasks = []taskr.Task{
		taskr.NewTask("", false, "[os] ", runOsCommands),
		taskr.NewTask("Close affected OS apps", false, "[os] ", closeOsApps),
	}
}

func runOsCommands(t *taskr.Task) {
	cmds := [][]string{
		{"Disable chrome two finger swipe", "defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false"},
		{"Set standby delay to 24 hours", "sudo pmset -a standbydelay 86400"},
		{"Disable boot sound effects", "sudo nvram SystemAudioVolume="},
		{"Expand save panel by default", "defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true"},
		{"Expand save panel by default", "defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true"},
		{"Save to disk by default (instead of iCloud)", "defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false"},
		{"Quit printer app once job is complete", "defaults write com.apple.print.PrintingPrefs \"Quit When Finished\" -bool true"},
		{"Disable app open confirmation", "defaults write com.apple.LaunchServices LSQuarantine -bool false"},
		{"Remote dups in Open With menu", "/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user"},
		{"Disable crash reporter", "defaults write com.apple.CrashReporter DialogType -string \"none\""},
		{"Set help viewer to non-floating mode", "defaults write com.apple.helpviewer DevMode -bool true"},
		{"Disable automatic capitalization", "defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false"},
		{"Disable smart dashes", "defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false"},
		{"Disable automatic period substitution", "defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false"},
		{"Disable smart quotes", "defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false"},
		{"Disable auto correct", "defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false"},
		{"Disable tap to click", "defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool false"},
		{"Disable tap to click", "defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 0"},
		{"Disable tap to click", "defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 0"},
		{"Disable three finger drag", "defaults write http://com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -int 0"},
		{"Disable three finger drag", "defaults write http://com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -int 0"},
		{"Enable full keyboard in all UI elements", "defaults write NSGlobalDomain AppleKeyboardUIMode -int 2"},
		{"Disable press and hold keys", "defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false"},
		{"Set fast key repeat", "defaults write NSGlobalDomain KeyRepeat -int 2"},
		{"Set fast key repeat", "defaults write NSGlobalDomain InitialKeyRepeat -int 9"},
		{"Require password immediately after sleep", "defaults write com.apple.screensaver askForPassword -int 1"},
		{"Require password immediately after sleep", "defaults write com.apple.screensaver askForPasswordDelay -int 0"},
		{"Save screenshots to screenshot dir", "defaults write com.apple.screencapture location -string \"${HOME}/Screenshots\""},
		{"Default to PNG for screenshots", "defaults write com.apple.screencapture type -string \"png\""},
		{"Enable subpixel font rendering on non-apple screens", "defaults write NSGlobalDomain AppleFontSmoothing -int 1"},
		{"Enable HiDPI display modes", "sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true"},
		{"All quit with ⌘ + Q", "defaults write com.apple.finder QuitMenuItem -bool true"},
		{"Set desktop as default location for finder windows", "defaults write com.apple.finder NewWindowTarget -string \"PfDe\""},
		{"Set desktop as default location for finder windows", "defaults write com.apple.finder NewWindowTargetPath -string \"file://${HOME}/\""},
		{"Hide icons for HDs, servers, and removable media on desktop", "defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false"},
		{"Hide icons for HDs, servers, and removable media on desktop", "defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false"},
		{"Hide icons for HDs, servers, and removable media on desktop", "defaults write com.apple.finder ShowMountedServersOnDesktop -bool false"},
		{"Hide icons for HDs, servers, and removable media on desktop", "defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false"},
		{"Show file extensions by default", "defaults write NSGlobalDomain AppleShowAllExtensions -bool true"},
		{"Show status bar in finder", "defaults write com.apple.finder ShowStatusBar -bool true"},
		{"Show path bar in finder", "defaults write com.apple.finder ShowPathbar -bool true"},
		{"Show full path as title in finder window", "defaults write com.apple.finder _FXShowPosixPathInTitle -bool true"},
		{"Show folders on top when sorting by name", "defaults write com.apple.finder _FXSortFoldersFirst -bool true"},
		{"Search current folder by default", "defaults write com.apple.finder FXDefaultSearchScope -string \"SCcf\""},
		{"Disable warning when changing file extension", "defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false"},
		{"Enable spring loading for directories", "defaults write NSGlobalDomain com.apple.springing.enabled -bool true"},
		{"Reduce spring loading delay", "defaults write NSGlobalDomain com.apple.springing.delay -float 0.2"},
		{"Avoid creating .DS_Store files on network or USB volumes", "defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true"},
		{"Avoid creating .DS_Store files on network or USB volumes", "defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true"},
		{"Disable disk image verification", "defaults write com.apple.frameworks.diskimages skip-verify -bool true"},
		{"Disable disk image verification", "defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true"},
		{"Disable disk image verification", "defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true"},
		{"Automatically open finder window when volume is mounted", "defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true"},
		{"Automatically open finder window when volume is mounted", "defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true"},
		{"Automatically open finder window when volume is mounted", "defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true"},
		{"Use column view in all finder windows", "defaults write com.apple.finder FXPreferredViewStyle -string \"clmv\""},
		{"Disable warning before emptying trash", "defaults write com.apple.finder WarnOnEmptyTrash -bool false"},
		{"Enable AirDrop over ethernet", "defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true"},
		{"Show the ~/Library folder", "chflags nohidden ~/Library"},
		{"Show the /Volumes folder", "sudo chflags nohidden /Volumes"},
		{"Expand file info panes", "defaults write com.apple.finder FXInfoPanesExpanded -dict General -bool true"},
		{"Expand file info panes", "defaults write com.apple.finder FXInfoPanesExpanded -dict OpenWith -bool true"},
		{"Expand file info panes", "defaults write com.apple.finder FXInfoPanesExpanded -dict Privileges -bool true"},
		{"Enable highlight hover effect for grid view", "defaults write com.apple.dock mouse-over-hilite-stack -bool true"},
		{"Set icon size of dock items to 16 pixels", "defaults write com.apple.dock tilesize -int 16"},
		{"Change min / max window effect", "defaults write com.apple.dock mineffect -string \"scale\""},
		{"Minimize windows into their app icon", "defaults write com.apple.dock minimize-to-application -bool true"},
		{"Enable spring loading for all dock items", "defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true"},
		{"Show indicator lights for open apps in dock", "defaults write com.apple.dock show-process-indicators -bool true"},
		{"Remove all default app icons from dock", "defaults write com.apple.dock persistent-apps -array"},
		{"Remove animation from opening dock items", "defaults write com.apple.dock launchanim -bool false"},
		{"Speed up mission control animations", "defaults write com.apple.dock expose-animation-duration -float 0.1"},
		{"Disable launchpad gesture", "defaults write com.apple.dock showLaunchpadGestureEnabled -int 0"},
		{"Do not send search queries to Apple", "defaults write com.apple.Safari UniversalSearchEnabled -bool false"},
		{"Do not send search queries to Apple", "defaults write com.apple.Safari SuppressSearchSuggestions -bool true"},
		{"Press tab to highlight items on websites", "defaults write com.apple.Safari WebKitTabToLinksPreferenceKey -bool true"},
		{"Press tab to highlight items on websites", "defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks -bool true"},
		{"Show full URL in address bar", "defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true"},
		{"Set safari homepage to about:blank", "defaults write com.apple.Safari HomePage -string \"about:blank\""},
		{"Prevent safari from automatically opening files after download", "defaults write com.apple.Safari AutoOpenSafeDownloads -bool false"},
		{"Hide safari sidebar in top sites", "defaults write com.apple.Safari ShowSidebarInTopSites -bool false"},
		{"Disable safari thumbnail cache", "defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2"},
		{"Enable safari debug menu", "defaults write com.apple.Safari IncludeInternalDebugMenu -bool true"},
		{"Make safari search with contain instead of starts with", "defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false"},
		{"Remove default icons from safari bookmarks bar", "defaults write com.apple.Safari ProxiesInBookmarksBar \"()\""},
		{"Enable developer menu in safari", "defaults write com.apple.Safari IncludeDevelopMenu -bool true"},
		{"Enable developer menu in safari", "defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true"},
		{"Enable developer menu in safari", "defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true"},
		{"Add context menu for web inspector", "defaults write NSGlobalDomain WebKitDeveloperExtras -bool true"},
		{"Enable spell check in safari", "defaults write com.apple.Safari WebContinuousSpellCheckingEnabled -bool true"},
		{"Disable autocorrect in safari", "defaults write com.apple.Safari WebAutomaticSpellingCorrectionEnabled -bool false"},
		{"Disable autofill in safari", "defaults write com.apple.Safari AutoFillFromAddressBook -bool false"},
		{"Disable autofill in safari", "defaults write com.apple.Safari AutoFillPasswords -bool false"},
		{"Disable autofill in safari", "defaults write com.apple.Safari AutoFillCreditCardData -bool false"},
		{"Disable autofill in safari", "defaults write com.apple.Safari AutoFillMiscellaneousForms -bool false"},
		{"Warn about fraudulent sites in safari", "defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true"},
		{"Disable plugins in safari", "defaults write com.apple.Safari WebKitPluginsEnabled -bool false"},
		{"Disable plugins in safari", "defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2PluginsEnabled -bool false"},
		{"Disable java in safari", "defaults write com.apple.Safari WebKitJavaEnabled -bool false"},
		{"Disable java in safari", "defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabled -bool false"},
		{"Disable autoplay videos in safari", "defaults write com.apple.Safari WebKitMediaPlaybackAllowsInline -bool false"},
		{"Disable autoplay videos in safari", "defaults write com.apple.SafariTechnologyPreview WebKitMediaPlaybackAllowsInline -bool false"},
		{"Disable autoplay videos in safari", "defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2AllowsInlineMediaPlayback -bool false"},
		{"Disable autoplay videos in safari", "defaults write com.apple.SafariTechnologyPreview com.apple.Safari.ContentPageGroupIdentifier.WebKit2AllowsInlineMediaPlayback -bool false"},
		{"Enable do not track in safari", "defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true"},
		{"Auto-update extensions in safari", "defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true"},
		{"Hide spotlight tray icon", "sudo chmod 600 /System/Library/CoreServices/Search.bundle/Contents/MacOS/Search"},
		{"Disable spotlight indexing for any attached index", "sudo defaults write /.Spotlight-V100/VolumeConfiguration Exclusions -array \"/Volumes\""},
		{"Update spotlight indexing", "defaults write com.apple.spotlight orderedItems -array '{\"enabled\" = 1;\"name\" = \"APPLICATIONS\";}' "},
		{"Update spotlight indexing", "defaults write com.apple.spotlight orderedItems -array '{\"enabled\" = 1;\"name\" = \"SYSTEM_PREFS\";}' "},
		{"Update spotlight indexing", "defaults write com.apple.spotlight orderedItems -array '{\"enabled\" = 1;\"name\" = \"DIRECTORIES\";}' "},
		{"Update spotlight indexing", "defaults write com.apple.spotlight orderedItems -array '{\"enabled\" = 1;\"name\" = \"PDF\";}' "},
		{"Update spotlight indexing", "defaults write com.apple.spotlight orderedItems -array '{\"enabled\" = 1;\"name\" = \"FONTS\";}' "},
		{"Update spotlight indexing", "defaults write com.apple.spotlight orderedItems -array '{\"enabled\" = 0;\"name\" = \"DOCUMENTS\";}' "},
		{"Update spotlight indexing", "defaults write com.apple.spotlight orderedItems -array '{\"enabled\" = 0;\"name\" = \"MESSAGES\";}' "},
		{"Update spotlight indexing", "defaults write com.apple.spotlight orderedItems -array '{\"enabled\" = 0;\"name\" = \"CONTACT\";}' "},
		{"Update spotlight indexing", "defaults write com.apple.spotlight orderedItems -array '{\"enabled\" = 0;\"name\" = \"EVENT_TODO\";}' "},
		{"Update spotlight indexing", "defaults write com.apple.spotlight orderedItems -array '{\"enabled\" = 0;\"name\" = \"IMAGES\";}' "},
		{"Update spotlight indexing", "defaults write com.apple.spotlight orderedItems -array '{\"enabled\" = 0;\"name\" = \"BOOKMARKS\";}' "},
		{"Update spotlight indexing", "defaults write com.apple.spotlight orderedItems -array '{\"enabled\" = 0;\"name\" = \"MUSIC\";}' "},
		{"Update spotlight indexing", "defaults write com.apple.spotlight orderedItems -array '{\"enabled\" = 0;\"name\" = \"MOVIES\";}' "},
		{"Update spotlight indexing", "defaults write com.apple.spotlight orderedItems -array '{\"enabled\" = 0;\"name\" = \"PRESENTATIONS\";}' "},
		{"Update spotlight indexing", "defaults write com.apple.spotlight orderedItems -array '{\"enabled\" = 0;\"name\" = \"SPREADSHEETS\";}' "},
		{"Update spotlight indexing", "defaults write com.apple.spotlight orderedItems -array '{\"enabled\" = 0;\"name\" = \"SOURCE\";}' "},
		{"Update spotlight indexing", "defaults write com.apple.spotlight orderedItems -array '{\"enabled\" = 0;\"name\" = \"MENU_DEFINITION\";}' "},
		{"Update spotlight indexing", "defaults write com.apple.spotlight orderedItems -array '{\"enabled\" = 0;\"name\" = \"MENU_OTHER\";}' "},
		{"Update spotlight indexing", "defaults write com.apple.spotlight orderedItems -array '{\"enabled\" = 0;\"name\" = \"MENU_CONVERSION\";}' "},
		{"Update spotlight indexing", "defaults write com.apple.spotlight orderedItems -array '{\"enabled\" = 0;\"name\" = \"MENU_EXPRESSION\";}' "},
		{"Update spotlight indexing", "defaults write com.apple.spotlight orderedItems -array '{\"enabled\" = 0;\"name\" = \"MENU_WEBSEARCH\";}' "},
		{"Update spotlight indexing", "defaults write com.apple.spotlight orderedItems -array '{\"enabled\" = 0;\"name\" = \"MENU_SPOTLIGHT_SUGGESTIONS\";}' "},
		{"Load new settings before rebuilding spotlight index", "killall mds > /dev/null 2>&1"},
		{"Enable indexing for main volume", "sudo mdutil -i on / > /dev/null"},
		{"Rebuild finder index", "sudo mdutil -E / > /dev/null"},
		{"Use UTF-8 in terminal app", "defaults write com.apple.terminal StringEncodings -array 4"},
		{"Enable secure keyboard entry in terminal app", "defaults write com.apple.terminal SecureKeyboardEntry -bool true"},
		{"Disable terminal line marks", "defaults write com.apple.Terminal ShowLineMarks -int 0"},
		{"Disable iterm quit prompt", "defaults write com.googlecode.iterm2 PromptOnQuit -bool false"},
		{"Disable time machine prompt for new hard drives", "defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true"},
		{"Disable local time machine backups", "hash tmutil &> /dev/null && sudo tmutil disablelocal"},
		{"Show main window when launching activity monitor", "defaults write com.apple.ActivityMonitor OpenMainWindow -bool true"},
		{"Disable CPU usage in activity monitor dock icon", "defaults write com.apple.ActivityMonitor IconType -int 5"},
		{"Show all processes in activity monitor", "defaults write com.apple.ActivityMonitor ShowCategory -int 0"},
		{"Sort activity monitor by cpu usage", "defaults write com.apple.ActivityMonitor SortColumn -string \"CPUUsage\""},
		{"Sort activity monitor by cpu usage", "defaults write com.apple.ActivityMonitor SortDirection -int 0"},
		{"Use plain text in text edit docs", "defaults write com.apple.TextEdit RichText -int 0"},
		{"Open sand save files as UTF-8 in text edit", "defaults write com.apple.TextEdit PlainTextEncoding -int 4"},
		{"Open sand save files as UTF-8 in text edit", "defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4"},
		{"Autoplay videos when opened with quicktime", "defaults write com.apple.QuickTimePlayerX MGPlayMovieOnOpen -bool true"},
		{"Enable dev tools in app store", "defaults write com.apple.appstore WebKitDeveloperExtras -bool true"},
		{"Enable automatic updates in app store", "defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true"},
		{"Check for software updates daily", "defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1"},
		{"Download software updates in background", "defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1"},
		{"Install system data files and security updates", "defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1"},
		{"Automatically download apps installed on other macs", "defaults write com.apple.SoftwareUpdate ConfigDataInstall -int 1"},
		{"Turn on app auto update", "defaults write com.apple.commerce AutoUpdate -bool true"},
		{"Disallow app store reboots", "defaults write com.apple.commerce AutoUpdateRestartRequired -bool false"},
		{"Prevent photos app from auto opening", "defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true"},
		{"Disable auto emoji substitution", "defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add \"automaticEmojiSubstitutionEnablediMessage\" -bool false"},
		{"Disable smart quotes", "defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add \"automaticQuoteSubstitutionEnabled\" -bool false"},
		{"Disable continuous spell checking", "defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add \"continuousSpellCheckingEnabled\" -bool false"},
		{"Disable chrome backswipe on trackpads", "defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false"},
		{"Disable chrome backswipe on trackpads", "defaults write com.google.Chrome.canary AppleEnableSwipeNavigateWithScrolls -bool false"},
	}

	t.Fn = func(tskr *taskr.Taskr) {
		for _, appleCmd := range cmds {
			title := appleCmd[0]
			tskr.Spinner.Message(cyan(title))
			cmd := exec.Command(SHELL, "-c", appleCmd[1])

			if _, err := cmd.CombinedOutput(); err != nil {
				prefix := fmt.Sprintf("%s%s", t.ErrContext, title)
				tskr.HandleTaskError(prefix, err)
			}
		}
	}
}

func closeOsApps(t *taskr.Task) {
	apps := []string{
		"Activity Monitor",
		"Address Book",
		"Calendar",
		"cfprefsd",
		"Contacts",
		"Dock",
		"Finder",
		"Mail",
		"Messages",
		"Photos",
		"Safari",
		"SystemUIServer",
		"iCal",
	}

	t.Fn = func(tskr *taskr.Taskr) {
		for _, appName := range apps {
			closeCmd := fmt.Sprintf("killall \"%s\" &> /dev/null", appName)
			cmd := exec.Command(SHELL, "-c", closeCmd)

			if _, err := cmd.CombinedOutput(); err != nil {
				appText := fmt.Sprintf("closing %s", appName)
				prefix := fmt.Sprintf("%s%s", t.ErrContext, appText)

				tskr.HandleTaskError(prefix, err)
			}
		}
	}
}
