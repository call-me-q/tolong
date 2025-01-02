use clap::Command;

pub mod init;

pub fn command_config_list() -> Vec<Command> {
    vec![init::config()]
}

pub fn command_handler_list() -> Vec<(&'static str, fn() -> Result<(), String>)> {
    vec![("init", init::handler)]
}
