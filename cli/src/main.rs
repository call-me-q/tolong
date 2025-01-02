mod cli;
mod commands;
mod subcommands;

use crate::{
    cli::{cli, run},
    commands::command_config_list,
};
use clap::Command;

fn main() {
    let cli: Command = cli(command_config_list());

    run(cli.get_matches());
}
