cask "brother-scannerdrivers-ica" do
  version "1.16.0"
  sha256 "ac24dc9ef5043009b2f2646e04861883d81baeb6d1d13139b1686028b80f59c0"

  # WARNING this driver might be for MFC-L2740DW models only
  url "https://download.brother.com/welcome/dlf106898/Brother_ScannerDrivers_ICA_#{version.dots_to_underscores}.dmg"
  name "Brother_ScannerDrivers_ICA"
  desc "Scanner driver for Brother all-in-one printers"
  homepage "https://support.brother.com/g/b/downloadhowto.aspx?c=fr&lang=fr&prod=mfcl2740dw_us_eu_as&os=10088&dlid=dlf106898_000&flang=11&type3=10279"
  # us homepage "https://support.brother.com/g/b/downloadhowto.aspx?c=us&lang=en&prod=mfcl2740dw_us_eu_as&os=10088&dlid=dlf106898_000&flang=4&type3=10279"
  pkg "Brother_ScannerDrivers_ICA.pkg"

  uninstall pkgutil: "com.Brother.Brotherdriver.Brother_ScannerDrivers_ICA"

  zap trash: "~/Library/Preferences/com.brother.scanner.ica.plist"

  caveats do
    reboot
  end
end