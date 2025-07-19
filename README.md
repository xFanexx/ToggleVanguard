# Riot Vanguard Toggle

Simple batch script to turn Riot Vanguard on/off when you're not gaming.

## The Deal

Vanguard runs 24/7 with kernel access even when you're not playing Valorant or League. That's kinda annoying if you just want to browse reddit without kernel-level stuff running in the background.

This script lets you disable it when you're done gaming and turn it back on when you want to play.

## What it does

**Disable mode**: Stops services, kills processes, renames files so Vanguard can't start
**Enable mode**: Puts everything back so your games work again

Pretty simple.

## How to use

1. Download the `.bat` file
2. Run it (needs admin rights)
3. Pick disable or enable
4. If enabling, you gotta restart your PC

That's it.

## Important stuff

- Your games won't start with Vanguard disabled (obviously)
- You need to restart after enabling Vanguard
- Files get renamed, not deleted, so it's reversible
- Works on Windows 10/11

## If something breaks

**"Vanguard directory not found"** - Make sure Vanguard is actually installed

**"Cannot determine state"** - Your Vanguard install might be messed up, try reinstalling

**Games won't launch** - Enable Vanguard first, then restart your computer

## Why this exists

Look, some people don't want kernel-level anti-cheat running when they're not gaming. Other anti-cheat systems like BattlEye only run when you launch the game. Vanguard doesn't give you that choice, so here's a way to get it.

This doesn't bypass or crack anything - it just gives you an off switch like you'd expect from any other software.

## Disclaimer

Use at your own risk. Don't blame me if something goes wrong. Always enable Vanguard before trying to play Riot games or you'll just get error messages.

---

Made because kernel-level stuff running 24/7 is weird.
