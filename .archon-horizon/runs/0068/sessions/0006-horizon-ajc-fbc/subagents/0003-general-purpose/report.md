Hygiene pass complete. Here's the report.

## (a) What I changed, and read back

**`AJC.fbc.cosimplicial` summary replaced** (135 → 1441 chars, read back via `roadmap list --focus`). The old prose — "Split the remaining degreewise Čech base-change naturality into the pushforward comparison and twisted-nerve compatibility obligations" — **did contradict both children**. It framed one naturality problem split two ways; the children (rewritten this session) say the pushforward leaf has **no naturality obligation left** (whiskered mate, residue is one `IsIso` per index tuple) and the twisted leaf is **not a whiskering at all** (comparison of two nerves). New text sourced only from the two children, with "do not price these together" as the operative instruction.

**`AJC.cohomology` summary replaced** (136 → 1539 chars, read back). Its flat-base-change sentence was wrong in both halves: "remains open at flat-pullback exactness" contradicts `AJC.fbc.exactness`, whose own summary says the arbitrary-module statement is a deliberate monument that should **not** be attempted; "and two cosimplicial naturality checks" mis-describes the leaves as above. New text names `cech_flatBaseChange_qcoh` as the form to consume and records the exact three sorry sites.

**Comment on `I-0570`** (`.archon-horizon/inbox/local/comments/I-0570/C-0002.md`, read back from disk). First attempt at 1500+ chars died on a CLI traceback (`AttributeError: 'NoneType' object has no attribute 'get'` in `scope_from_dict`) and **wrote nothing** — a different failure mode from I-0612's last-line rejection. Retried at 986 chars, landed.

## (b) Needs the lane's own attention

**`I-0570` is half-refuted and still open, kind `memory`, labelled agent-ready.** Its headline claim — "THE TWO CECH NATURALITY SQUARES NEED PER-SIGMA PROJECTION LEMMAS THAT DO NOT EXIST ... genuinely the multi-hundred-line build" — is false for the pushforward leaf after r2. I commented rather than archived, because the twisted half stands and the item's Pi.hom_ext measurement is still the sharpest record. **The lane should decide whether to supersede it with a twisted-only restatement.** Its stale line numbers (`~:2202`, `~:2273`, `:682`) are now `:2512`, `:2600`, `:853`.

**`I-0580` and `I-0581` were already archived** (both `updated_at` 14:08, status `archived`) before this pass. Nothing to do; if the lane's final report says it archived them this round, that's a re-derivation, not a new action.

**`I-0569` no longer asserts the false version.** I grepped its body for "finite product"/"missing" and got zero hits — the correction landed in the body itself, and the standing comment records the refutation plus `isQuasicoherent_pi_of_isAffineBase`. No text to quote back; nothing to fix.

**Duplicate-shaped pair worth one look:** `isQuasicoherent_pi_of_isAffineBase` (:518) and `isQuasicoherent_pi_of_isAffine` (:537) both exist in `CechHigherDirectImageUnconditional.lean`, 3 and 4 references respectively. Not a defect, but two roadmap summaries name only one of them each, so a reader may think one is missing.

**No parent/child status disagreement in this lane's subtree.** `AJC.cohomology` pending over one active child (`AJC.fbc`) and three done children; `AJC.fbc` active over three pending leaves. Coherent. `subtree_done` on `AJC.fbc` reads 0/4 while `AJC.cohomology.tilde-exact` is done — that's correct, tilde-exact is a sibling of `AJC.fbc`, not a child.

**Verification I ran:** all 17 declarations advertised across the lane's summaries and inbox items exist in-tree (`cech_flatBaseChange_qcoh`, `isQuasicoherent_cechComplex_X`, `cechOuterBC`, `isIso_app_pi_of_isIso_app`, `openImmersion_beckChevalley`, `coverInterOpen_baseChange_eq`, and the rest) — no advertised-but-absent carriers, per I-0624. Sorry census as a term over `AlgebraicJacobian/Cohomology/`: exactly 3, all in `CechHigherDirectImageUnconditional.lean` at `:853` (`pullback_preservesMonomorphisms`), `:2512` (`cech_pushforward_baseChange_natIso`), `:2600` (`twisted_cech_nerve_iso`). 30+ other "sorry" matches are docstring prose. I did not run a build.

## (c) Warnings and files I'm deliberately leaving

**No stray deletions.** My first `status --porcelain | grep '^D'` returned four `D` paths, all outside this lane. That was a **transient read across another lane's in-flight commit** — two re-runs at HEAD `117857598` return `none`, the index diff is empty, and all four paths exist on disk. Treat the earlier reading as noise, not as a lane artifact. No non-`M` entries under `Cohomology/`.

**Root scratch files: 13 `.lean` files, none of them this lane's to remove.** `.gitignore:26` (`*Probe*.lean`) already covers `GroundProbe*.lean`, `Probe3/4.lean`, and `Probe12.lean`; `:27` (`/scratch_*.lean`) covers `scratch_pd.lean`. Three are **not ignored**: `probe_deg.lean`, `probe_root.lean` (both untracked, showing as `??`) and **`probe_pd.lean`, which is TRACKED in the ledger**. All three import `RiemannRoch`/`Picard` modules — they belong to `ajc-rr`/`ajc-pic0av`, mtimes 19:55–22:11. I did not touch them. `ScratchAudit0010.lean` appeared in the initial glob but no longer exists — another lane cleaned it mid-pass. A lowercase `probe_*` pattern would close the gap, but that's a shared-file edit affecting three lanes' live work, so I left it.

**The 18-active-items and 102-open-items warnings stay.** Both triaged as legitimate under 8 live lanes (I-0509, I-0556). I made no status changes to create or mask them. The three unrelated warnings (`AJC.jacobian.assembly`, `AJC.picrep`, `AJC.rr` all-children-done) are outside this lane and I left them for their owners.

**I wrote no mathematical claims of my own.** Every sentence in both new summaries is traceable to a child summary or to a declaration I confirmed exists.
