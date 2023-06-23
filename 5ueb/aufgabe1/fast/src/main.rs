use std::fs::File;
use std::io::{self, BufRead};
use std::process::Command;
use rayon::prelude::*;

fn main() {
    let password1 = "07v0C21Z$2FH7ib2Dxtoq6B83qTgON1";
    let password2 = "Jebn3vQ5$2k..iqxtXNwfsCFAamWCS0";
    let password3 = "0ngrMRa1$uXLzWhnrYzmiRM3fi8Nde1";
    let password4 = "1aaPttrp$VoF2rkOyC/tE.DxzQuuIY1";
    let password5 = "7ieEwjFr$T/jwatbzqhLZNVDEfymB41";

    if let Ok(file) = File::open("words.txt") {
        let reader = io::BufReader::new(file);
        let lines: Vec<String> = reader.lines().map(|line| line.unwrap()).collect();

        let results: Vec<(String, String)> = lines.par_iter().flat_map(|line| {
            let mut line_results = Vec::new();
            for password in &[password1, password2, password3, password4, password5] {
                let hash = openssl_passwd(&line, password).unwrap();
                let hash = &hash[3..];

                if hash == *password {
                    line_results.push((line.clone(), password.to_string()));
                }
            }
            println!("{}", line);
            line_results
        }).collect();

        for (line, password) in results {
            println!("The password for {} is {}", password, line);
        }
    }
}

fn openssl_passwd(line: &str, password: &str) -> io::Result<String> {
    let output = Command::new("openssl")
        .arg("passwd")
        .arg("-1")
        .arg("-salt")
        .arg(password)
        .arg(line)
        .output()?;

    if output.status.success() {
        let hash = String::from_utf8_lossy(&output.stdout).trim().to_string();
        Ok(hash)
    } else {
        let error = String::from_utf8_lossy(&output.stderr).trim().to_string();
        Err(io::Error::new(io::ErrorKind::Other, error))
    }
}
