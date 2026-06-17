# Iter 024 — Review (Quot-Foundations)

## Verdict

Build GREEN (both prover-edited modules `lake build` EXIT 0 — FBC 8318 jobs, QUOT 8317; only expected
`sorry` + linter/deprecation warnings). Both modules `lean_verify` axiom-clean
`{propext, Classical.choice, Quot.sound}`. blueprint-doctor: **0 findings**. dag: `gaps=0`,
`unmatched=2` (the 2 new QUOT theorems — coverage debt). sync_leanok ran on this tree (sha `abf7575`):
+7 `\leanok`, chapters_touched = `Cohomology_FlatBaseChange.tex`, `Picard_QuotScheme.tex`. **2 prover
lanes (FBC fine-grained, QUOT keystone mathlib-build). Net −1 active sorry; +6 axiom-clean declarations
closed.** All 3 review subagents returned (lean-auditor + 2 lean-vs-blueprint-checkers): **0 Lean-side
critical; 1 must-fix stale `.lean` comment; 2 major blueprint-adequacy/coverage items.**

**Headline: the iter-021→024 effort-breaker chain paid off.** The decomposed FBC `gstar_transpose` wall
yielded **3 `inner_eCancel` atoms closed axiom-clean** (small one-/three-line lemmas) plus **Seam B
`gstar_generator_close` closed by `rfl`** — the iter-023 conjectured element-lemma re-break was
unnecessary. The GF/QUOT-shared keystone retarget produced **2 axiom-clean affine-localization
theorems** (the Spec-affine engine); the general keystone stays blocked on two confirmed Mathlib-absent
ingredients.

## Overall progress this iter (active `sorry` per file)

- **FlatBaseChange (FBC) 6 → 5 (−1, +4 axiom-clean lemmas).** Three new atoms
  `base_change_mate_inner_eCancel_{eUnit,pushforwardComp,pullbackComp}` CLOSED axiom-clean; Seam B
  `base_change_mate_gstar_generator_close` CLOSED by `rfl`. Seam A `base_change_mate_inner_value_eq`
  @1617 PARTIAL — scaffold + proved atoms in place, blocked on the recurring **literal-form-lock** (the
  surviving `pushforwardComp.hom` factor prints identically to atom 2's LHS but `rw`/`simp`/explicit
  `have…rw` all fail to match on invisible implicit args). `gstar_transpose` @1800 PARTIAL, gated on
  Seam A. Dead `fstar_reindex_legs` @1421; affine @1983; FBC-B @2005 untouched.
- **QuotScheme (QUOT) 4 → 4 (+2 axiom-clean theorems, no net sorry change).** Two NEW theorems —
  `isLocalizedModule_tilde_restrict` (~L456, basic-open restriction of a `tilde` sheaf localizes) and
  `isLocalizedModule_restrict_of_isIso_fromTildeΓ` (~L510, transports it to any essImage sheaf). The
  general keystone `Scheme.Modules.isLocalizedModule_basicOpen` NOT added (would need a sorry) — gated on
  gap1 (`IsQuasicoherent M → IsIso M.fromTildeΓ`, descent-level, Mathlib-absent) + gap2 (affine
  `U ↦ Spec Γ(X,U)` transport + Ab↔ModuleCat reconciliation). The 4 sorries are the unchanged protected
  stubs.
- **GF / other modules** — no prover this iter; untouched. `genericFlatnessAlgebraic` remains
  axiom-clean; `genericFlatness` @2264 remains the sole GF sorry (gated on G1/G3 → keystone).

## Subagent findings (acted on)
- **lean-auditor `iter024`** (0 crit / 1 must-fix / rest clean): MF-1 (major) = stale "REMAINING CRUX"
  comment in `base_change_mate_gstar_transpose` (~L1797–1809) still naming the now-proved generator
  close as outstanding. Review cannot edit `.lean` → passed to recommendations for a comment-cleanup.
  All 6 new decls verified correct; QUOT section docstring accurate; sorry inventory matches the known
  list across all 8 files. Report: `.archon/task_results/lean-auditor-iter024.md`.
- **lean-vs-blueprint-checker `fbc-iter024`** (0 must-fix / 1 major / 2 minor): 3 atoms axiom-clean with
  exact signature matches; `gstar_generator_close` faithfully described + rfl-closed; **major** =
  `lem:base_change_mate_inner_value_eq` under-specified for the literal-form-lock (chapter must prescribe
  the pre-subst order or `conv`/position route — gates the next Seam A prover). Minors: `gammaMap_pushforwardCongr_hom`
  prose says "identity" but Lean gives `eqToHom`; `gstar_generator_close` sketch routes through general
  `r'⊗m` vs Lean's `1⊗ₜx` (equivalent). Report:
  `.archon/task_results/lean-vs-blueprint-checker-fbc-iter024.md`.
- **lean-vs-blueprint-checker `quot-iter024`** (0 red flags; major coverage debt): the 2 new theorems
  need `\lean{}` blocks; keystone `% NOTE` accurate + pin correctly unmarked; keystone proof sketch needs
  the 2 intermediates in `\uses{}` + gap2 flagged. Report:
  `.archon/task_results/lean-vs-blueprint-checker-quot-iter024.md`.

## Blueprint markers updated (manual)
- `Picard_QuotScheme.tex`, `lem:qcoh_section_localization_basicOpen`: added `% NOTE (iter-024 review)` —
  pinned decl `isLocalizedModule_basicOpen` does NOT exist yet; names the 2 affine ingredients built this
  iter + the 2 Mathlib-absent prerequisites (gap1/gap2). Pin left unmarked.
- No `\leanok` touched (sync-owned). No `\mathlibok` (both new theorems are project proofs). No `\lean{}`
  renames (FBC atom names match the planned pins; QUOT theorems have no blocks yet → coverage debt).

## What shaped iter-025 (live frontiers)
1. **FBC Seam A is one blueprint-writer round from a high-confidence close.** All 3 atoms proved + the
   scaffold in place; the ONLY gap is the literal-form-lock, which is a blueprint-adequacy gap (prescribe
   the `conv`/position OR pre-subst free-form route). Do NOT re-dispatch on the thin block — it churns.
   Then `gstar_transpose` cascades.
2. **QUOT coverage debt + keystone gaps.** Add blueprint blocks for the 2 new theorems; expand the
   keystone sketch; then blueprint gap1 (the real math, `IsQuasicoherent → IsIso fromTildeΓ`, via a
   reference-retriever on the Stacks "QCoh = essImage of tilde" tag) and gap2 BEFORE any keystone prover.
3. **GF-geo stays deferred** until the keystone lands; then decide shared-extraction vs import.
4. **Stale FBC gstar comment** (lean-auditor MF-1) — fold into the next FBC prover or a cleanup slot.

## Subagent skips
- (none) — both review-mandatory subagents dispatched: lean-auditor `iter024`, lean-vs-blueprint-checker
  ×2 (`fbc-iter024`, `quot-iter024`). Both `.lean` files received prover work this iter, so neither
  checker was skippable.
