Cleanup done and committed. Here's what changed.

## What I did

**Archived 6 items**, each verified against HEAD rather than judged by age:

- **I-0719** — `[temporary]` armed stale-index report. Its owner (`ajcr-divrep`) confirmed the three paths were its own and cleared them; I re-crossed the whole ledger index and it is **empty**, zero armed paths.
- **I-0570** — both central claims about the two Čech naturality squares were refuted by its own lane's later comments; the body is stale in full, and the live state lives in I-0651.
- **I-0722** — all three phantom declaration names are gone (checked declaration-shaped per I-0717, since those files now cite AJCR names in prose to assert their absence), and both dead `set_option`s were removed.
- **I-0721** — the "`Nat.find` per field" claim about AJCR is retracted *in place* at all five cited sites, including the synced hgraph node.
- **I-0638** — duplicate of I-0605/I-0708 after `.quot`/`.serre` went `rejected`; five lanes had each re-reported it.
- **I-0659** — absorbed into I-0600. Its whole reason to exist was a wider unrooted set, and those six `Picard/`+`Albanese/SymPow*` modules are rooted at HEAD.

**Filed 3 items:** I-0751 (the four orphaned `ajc-pic0av` threads), I-0750 (a janitor lesson, below), and the triage deltas on I-0509/I-0641/I-0648.

**Fixed both project READMEs** (commit `35d112a98`): AJC 273→284 modules / 158,653→163,544 lines, unrooted 18→**19**, bare `import Mathlib` 81→**99**, `Ledger/` 54→55 files; AJCR 728→737 files, unrooted 20→**17**. I also replaced AJC's stale per-module unrooted list with a pointer to I-0600, which carries the current one.

## I made a mistake worth flagging

I commented on **I-0720** saying its finding had not landed and should stay open. Wrong on both counts. The owning lane had archived it six minutes before my comment, and a cover-free `genus_baseChangeField_curve` (`GenusFieldInvariance.lean:409`, curve binders only, proved via the theorem `nonempty_affineCoverMVSquare_of_curve`) does exactly what the thread asked. I measured only the declaration I already knew about at `:332`. Retracted on the item and recorded as **I-0750** — a stale start-of-pass snapshot plus "measure only what you already know" is how a hygiene pass manufactures a false "still open".

## Your armed-set question

All four AJCR paths you reported are safe: byte-identical to HEAD, and the whole-index cross is now **zero armed paths** — their owners cleared them. On routing: there is no mechanism to notify a *queued* lane, so the honest answer is that a DM only works for a running one. What worked here was the pattern you already used: report the paths in an item, and the owner replies and clears. For paths whose owner has exited, an `issue` scoped to the project is the only durable route, which is what I did for the pic0av threads in I-0751.

## Warnings that survive, intentionally

| Warning | Verdict |
|---|---|
| `AJC.rr` done / `AJC.rr.extuniform` active | **Deliberate, untouched.** Read I-0736 first; the row is `active`, owner `ajc-rr`. |
| `AJC.picrep` done / `.tensor` open, `AJC.jacobian.assembly` | Not mine. Delta only per I-0556 rule 1 — the ask **narrowed from three children to one**, recorded on I-0605. |
| Roadmap 20→**21** active | Zero stale. 7 held by live lanes, 6 active ancestors, 8 leftover — all owned by lanes that exited within hours. |
| Tasks **13** (5 running + 8 queued) | Every queued task is a charter or has open roadmap refs. |
| Memory 83→**94**, non-protection 162→**136** visible | Structural (I-0551/I-0641). |

Two findings about the caps themselves. The **memory cap rose while I archived**, partly from my own filings — a pass that both archives and files cannot converge it. And the **roadmap leftover set grew 1→8 purely from fleet contraction** (8→5 lanes during the day): the task total stayed pinned at 13 because a lane that stops just moves columns. That method now needs a third bucket, *recently-exited*, beside *live* and *stale*.

I archived no protection, and I applied I-0625's test to every retired-lane memory (`ajc-gate`, `ajc-truth`, and the `ajcr-*` certificate set) — **all ten still have live instances in the open set**, so none was archivable despite being from finished lanes. No `.lean` file was touched.
