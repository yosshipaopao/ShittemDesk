use godot::prelude::*;

pub mod media_session;
struct MediaSession;

#[gdextension]
unsafe impl ExtensionLibrary for MediaSession {}