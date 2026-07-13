---
description: brjsas checkpoint — refresh state snapshot, update memory, write a handoff in the current dir
---

Run a full **`brjsas`** session checkpoint for Roman. Do all three steps below, in order, adapting to this project's existing conventions, then report a short summary. Act without asking unless something is genuinely ambiguous.

Resolve today's date as `YYYYMMDD` first (use the date already in context, or run `date +%Y%m%d`).

## 1 — State snapshot (in the current working directory)
If this project already uses a live-state pull convention — e.g. a `jira.txt` creds file plus `snap_YYYYMMDD/` snapshot dirs, or any similar dated snapshot pattern — **refresh it**: create `snap_<YYYYMMDD>/` in the CWD and save a fresh pull of the live external state (Jira / API / etc.) into it, matching the file layout of the most recent existing snapshot. Only use credentials and endpoints the project already uses — never invent them. If the project has no such convention, skip the raw snapshot and capture state narratively in the handoff (step 3) instead.

## 2 — Persistent memory
If this project has an auto-memory system (a `MEMORY.md` index + a `memory/` dir), update it per your standing memory instructions: add or curate memory files for anything durable decided or learned this session, correct stale ones, delete anything proven wrong, and keep `MEMORY.md` in sync (one line per memory). Keep session-only detail **out** of memory — that belongs in the handoff. If there is no memory system, fold the durable notes into the handoff instead.

## 3 — Handoff (in the current working directory)
Write a handoff markdown file in the CWD so a cold future session can resume from it. **Match the directory's existing convention**: if `handoffN.md` / `HANDOFF*.md` files already exist, continue the numbering and match their **language and structure** (Roman's handoffs are in Russian); otherwise create `handoff_<YYYYMMDD>.md`. Cover: date; TL;DR; what was done this session; the current state of each active thread with ticket/file references; open points, blockers, and what is gated on whom; next steps; and pointers to the step-1 snapshot and the prior handoffs so the chain stays navigable.

## Report
Finish with three short lines: the snapshot dir written (or "skipped — no convention"), the memory files created/updated, and the handoff filename.
