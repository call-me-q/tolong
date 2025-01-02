use clap::{ArgMatches, Command};

use crate::commands::command_handler_list;

fn base() -> Command {
    return Command::new("tolong")
        .name("Tolong")
        .about("Making your monorepo easy again.")
        .bin_name("tolong")
        .subcommand_precedence_over_arg(true)
        .subcommand_required(true);
}

pub fn cli(commands: Vec<Command>) -> Command {
    let base_cli: Command = base();
    return base_cli.clone().subcommands(commands);
}

// Refactored run function using match
pub fn run(matches: ArgMatches) -> () {
    // Get the subcommand from the matches
    match matches.subcommand() {
        // Check if a subcommand was provided
        Some((command, _)) => {
            // Use match to find the handler for the command
            match command_handler_list()
                .iter()
                .find(|(cmd, _)| *cmd == command)
            {
                // If the handler is found, call the handler function
                Some((_, handler)) => match handler() {
                    Ok(()) => println!("{} command executed successfully.", command),
                    Err(e) => println!("Error executing {} command: {}", command, e),
                },
                // If the command is not found in the handler list
                None => println!("Unknown command: {}", command),
            }
        }
        // If no subcommand is provided
        None => println!("Please provide a valid subcommand."),
    }
}
