Pod::Spec.new do |s|
    s.name         = "ReachableScreen"
    s.version      = "1.0.0"
    s.summary      = "ReachableScreen increases reachability of UI elements on large screen 3D-touch devices"
    s.description  = "This framework increases reachability of UI elements on iOS apps running on devices with 3D-touch by creating small visualization of the display using force touch"
    s.homepage     = "https://github.com/c0defather/ReachableScreen"
    s.license      = "Apache 2.0"
    s.author             = { "Kuanysh Zhunussov" => "kuanysh.zhunussov@gmail.com" }
    s.platform     = :ios, "9.0"
    s.swift_version = "4.0"
    s.source       = { :git => "https://github.com/c0defather/ReachableScreen.git", :tag => "1.0.0" }
    s.source_files  = "ReachableScreen/**/*"
end
