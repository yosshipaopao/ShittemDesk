use std::panic;
use godot::classes::Node;
use godot::prelude::*;
use windows::Media::Control::{GlobalSystemMediaTransportControlsSessionManager,GlobalSystemMediaTransportControlsSessionPlaybackStatus};
use windows::Media::MediaPlaybackType;

#[derive(GodotClass)]
#[class(base=Node)]
pub struct MediaSession {
    session_manager: GlobalSystemMediaTransportControlsSessionManager,
    base: Base<Node>,
}
 
#[godot_api]
impl MediaSession {
    #[func]
    pub fn get_status(&mut self) -> i32{
        let result = panic::catch_unwind(|| {
            let session = self.session_manager.GetCurrentSession().unwrap();
            let playback_info = session.GetPlaybackInfo().unwrap();
            let status = playback_info.PlaybackStatus().unwrap();
            match status {
                GlobalSystemMediaTransportControlsSessionPlaybackStatus::Changing => return 2,
                GlobalSystemMediaTransportControlsSessionPlaybackStatus::Closed => return 0,
                GlobalSystemMediaTransportControlsSessionPlaybackStatus::Opened => return 1,
                GlobalSystemMediaTransportControlsSessionPlaybackStatus::Paused  => return 5,
                GlobalSystemMediaTransportControlsSessionPlaybackStatus::Playing => return 4,
                GlobalSystemMediaTransportControlsSessionPlaybackStatus::Stopped => return 3,
                _ => return -1,
            }
        });
        if result.is_ok() {
            return result.unwrap();
        }else{
            return -1;
        }
    }
    #[func]
    pub fn get_seek(&mut self) -> Array<i64>{
        let result = panic::catch_unwind(|| {
            let session = self.session_manager.GetCurrentSession().unwrap();
            let timeline_properties = session.GetTimelineProperties().unwrap();
            let endtime = timeline_properties.EndTime().unwrap().Duration;
            let position = timeline_properties.Position().unwrap().Duration;
            return array![endtime,position];
        });
        if result.is_ok() {
            return result.unwrap();
        }else{
            return array![-1,-1];
        }
    }
    #[func]
    pub fn set_seek(&mut self, s:i64) -> bool{
        let result = panic::catch_unwind(|| {
            let session = self.session_manager.GetCurrentSession().unwrap();
            let result = session.TryChangePlaybackPositionAsync(s).unwrap().GetResults().unwrap();
            return result;
        });
        if result.is_ok(){
            return result.unwrap();
        }else {
            return false;
        }
    }
    #[func]
    pub fn get_media_type(&mut self) -> i64 {
        let result = panic::catch_unwind(|| {
            let session = self.session_manager.GetCurrentSession().unwrap();
            let playback_info = session.GetPlaybackInfo().unwrap();
            let playback_type = playback_info.PlaybackType().unwrap().Value().unwrap();
            match playback_type {
                MediaPlaybackType::Image => return 3,
                MediaPlaybackType::Music => return 1,
                MediaPlaybackType::Unknown => return 0,
                MediaPlaybackType:: Video   => return 2,
                _ => return -1,
            }
        });
        if result.is_ok() {
            return result.unwrap();
        }else{
            return -1;
        }
    }
    #[func]
    pub fn get_media_title(&mut self) -> String {
        let result = panic::catch_unwind(|| {
            let session = self.session_manager.GetCurrentSession().unwrap();
            let playback_info = session.TryGetMediaPropertiesAsync().unwrap().get().unwrap();
            let title = playback_info.Title().unwrap().to_string();
            return title;
        });
        if result.is_ok() {
            return result.unwrap();
        }else{
            return "".to_string();
        }
    }
    #[func]
    pub fn get_media_artist(&mut self) -> String {
        let result = panic::catch_unwind(|| {
            let session = self.session_manager.GetCurrentSession().unwrap();
            let playback_info = session.TryGetMediaPropertiesAsync().unwrap().get().unwrap();
            let artist = playback_info.Artist().unwrap().to_string();
            return artist;
        });
        if result.is_ok() {
            return result.unwrap();
        }else{
            return "".to_string();
        }
    }
    #[func]
    pub fn play_media(&mut self) -> bool{
        let result = panic::catch_unwind(|| {
            let session = self.session_manager.GetCurrentSession().unwrap();
            let result = session.TryPlayAsync().unwrap().GetResults().unwrap();
            return result;
        });
        if result.is_ok(){
            return result.unwrap();
        }else {
            return false;
        }
    }
    #[func]
    pub fn pause_media(&mut self) -> bool{
        let result = panic::catch_unwind(|| {
            let session = self.session_manager.GetCurrentSession().unwrap();
            let result = session.TryPauseAsync().unwrap().GetResults().unwrap();
            return result;
        });
        if result.is_ok(){
            return result.unwrap();
        }else {
            return false;
        }
    }
    #[func]
    pub fn toggle_play_pause_media(&mut self) -> bool{
        let result = panic::catch_unwind(|| {
            let session = self.session_manager.GetCurrentSession().unwrap();
            let result = session.TryTogglePlayPauseAsync().unwrap().GetResults().unwrap();
            return result;
        });
        if result.is_ok(){
            return result.unwrap();
        }else {
            return false;
        }
    }
    #[func]
    pub fn skip_next_media(&mut self) -> bool {
        let result = panic::catch_unwind(|| {
            let session = self.session_manager.GetCurrentSession().unwrap();
            let result = session.TrySkipNextAsync().unwrap().GetResults().unwrap();
            return result;
        });
        if result.is_ok(){
            return result.unwrap();
        }else {
            return false;
        }
    }
    #[func]
    pub fn skip_previous_media(&mut self) -> bool {
        let result = panic::catch_unwind(|| {
            let session = self.session_manager.GetCurrentSession().unwrap();
            let result = session.TrySkipPreviousAsync().unwrap().GetResults().unwrap();
            return result;
        });
        if result.is_ok(){
            return result.unwrap();
        }else {
            return false;
        }
    }
}
#[godot_api]
impl INode for MediaSession {
    fn init(base: Base<Node>) -> Self {
        let manager = GlobalSystemMediaTransportControlsSessionManager::RequestAsync().unwrap().get().unwrap();
        MediaSession {
            session_manager: manager,
            base,
        }
    }
}