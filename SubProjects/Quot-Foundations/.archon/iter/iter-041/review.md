# Iter 041 — Review (Quot-Foundations)

## Verdict
Build GREEN — the prover-touched module `QuotScheme.lean` `lake build` exit 0 (8317 jobs; only
style-linter / `maxHeartbeats`-comment / long-docstring-line warnings + the 4 pre-existing protected
iter-176 scaffold `sorry`s). `FlatBaseChange.lean` compiles 0 errors (the open `_legs_conj` sorry +
pre-existing style/deprecation warnings only). Both headline QUOT decls
`lean_verify` = `{propext, Classical.choice, Quot.sound}` (independently re-checked this phase). The
"opaque" source-scan warning at QuotScheme:2025 is the literal word in a docstring, not a declaration.
blueprint-doctor: **0 findings**. `sync_leanok` (iter 41, sha `ea57394`): **+6 `\leanok`, 0 removed**
(Picard_QuotScheme only). leandag `gaps=0`, `frontier=6`, `unmatched=4`.

**KEYSTONE ITER — QUOT gap1 CLOSED axiom-clean.** `isIso_fromTildeΓ_of_isQuasicoherent` (gap1) +
`isLocalizedModule_basicOpen_descent` (keystone) + the full geometric `Hfr` producer chain (5 supporting
decls) all landed kernel-axiom-clean. The ~14-iter QUOT gap1 arc (the section-localization descent for
quasi-coherent modules on `Spec R`, Hartshorne II.5.3 / Stacks `lemma-invert-f-sections`, built WITHOUT
the global `QCoh ≃ Mod` equivalence) is complete. Net active sorry: QUOT 4→4 (only the frozen protected
stubs remain), FBC 4→4. **FBC: the FINAL in-loop conjugate round (Fallback B) made verified partial
progress (the Γ-collapse stage now lands in-proof) but did NOT close `_legs_conj` — the multi-layer
composite-adjunction recognition has resisted 5 iters (037–041). Per the armed protocol the conjugate
route is exhausted in-loop; the chosen pivot is the affine tilde-transport route (needs blueprint +
scaffold + user steer).**

## Overall progress this iter (active `sorry` per file)
- **QUOT 4 → 4 stubs (gap1 + keystone + full Hfr producer chain LANDED — LANE-DEFINING CLOSE).** +7
  axiom-clean non-private decls:
  - `image_basicOpen_of_affine` (opaque-`j` image-of-basic-open: `j ''ᵁ D(f') = (Spec R).basicOpen
    ((j.appIso ⊤).inv ((ΓSpecIso S).inv f'))`, via `← basicOpen_eq_of_affine` + `Scheme.image_basicOpen`).
  - `compositeBasicOpenImmersion_image_basicOpen` (thin concrete instantiation of the above).
  - `image_basicOpen_eq_inf` (opaque-`j`: image as `(j ''ᵁ ⊤) ⊓ (Spec R).basicOpen g`, via `Scheme.basicOpen_res`).
  - `section_localization_hfr_aux` (the heavy **opaque-`j`** core: combiner `isLocalizedModule_powers_transport`
    + section isos `e₁/e₂` + restriction intertwiner + `eqToHom`/`of_linearEquiv` open-transport).
  - `section_localization_hfr_basicOpen` (TOP: thin wrapper instantiating the aux at `j =
    compositeBasicOpenImmersion`, `f' = σ⁻¹(algebraMap R A f)`, `U=D(s)`, `V=D(f)⊓D(s)`).
  - `isLocalizedModule_basicOpen_descent` (**keystone**: instantiates the cover-descent at the finite QCoh
    basic-open cover feeding the producer per overlap).
  - `isIso_fromTildeΓ_of_isQuasicoherent` (**gap1**: feeds the keystone into the existing assembler).
  **Load-bearing lesson (the reason this churned ~5 iters):** the final form-coercion `RESULT' := RESULT`
  is a >3.2M-heartbeat `whnf` runaway when `j` is the concrete triple-composite immersion (the kernel
  unfolds it); with `j` kept OPAQUE in the helper it is a cheap `rfl`. Mirrors `image_basicOpen_of_affine`.
  The analogist `quot-sigma-rebasing` defeqs were all confirmed `rfl` (the `S`-vs-`Γ(Spec S,⊤)` re-basing
  is definitional). Plan's separate (c)/(d) lemmas were inlined into the aux, not built standalone.
- **FBC 4 → 4 (Γ-collapse partial LANDED; cross-layer recognition BLOCKED — route exhausted in-loop).**
  No new decls; the open `sorry` in `base_change_mate_fstar_reindex_legs_conj` gained a verified in-proof
  Γ-collapse `simp` stage (`gammaMap_pushforwardComp_inv_eq_id`, `gammaMap_pushforwardCongr_hom` — collapses
  2 of 3 transparent coherences, reducing the goal to the cross-layer core). New sub-blocker surfaced: the
  remaining `(pushforwardComp g' (Spec φ)).hom` factor is `rfl`-`𝟙` yet resists `simp`/`rw` matching
  asymmetrically with the `.inv` form. The HEAVY recognition crux (S2 — the multi-layer composite
  `adjL`/`adjR` + assembled `β`) is unchanged across 037–041 and is a genuine Mathlib-absent construction.
  **Armed kill-criterion: this was the LAST in-loop conjugate round; no further conjugate/analogist rounds.**
- **GR 0 (untouched — properness lane closed iter-038).** GR-quot/repr is a new-file phase.
- **GF 1 (untouched), was gated on gap1 — now UNBLOCKED.** G1-core / GF-G1 / annihilator forward direction
  become attemptable next iter.

## Strategic state — two forks resolved opposite ways
- **QUOT: CONVERGED.** The ~14-iter gap1 arc closed. The progress-critic's standing OVER_BUDGET flag is
  now moot for gap1; the lane pivots to P2 / the downstream consumers (G1-core, GF, annihilator).
- **FBC: in-loop conjugate route EXHAUSTED.** Not mathematically dead (atoms all in hand) but the
  multi-layer recognition is a bespoke construction that 5 dedicated iters could not assemble. The planner's
  pre-armed cheapest-reversal-signal resolves the fork: open the affine **tilde-transport** route bypassing
  `gstar_transpose` (a structurally different route), gated on a blueprint section + scaffold + user steer.
  Do NOT re-dispatch any conjugate-class prover or analogist on `_legs_conj`.

## Critic / auditor dispositions (this review phase)
- **lean-auditor `iter041`** (both files): see `recommendations.md §3` / `summary.md` — findings landed there.
- **lean-vs-blueprint-checker `quot-iter041`**: see `recommendations.md §1–§2`.
- **lean-vs-blueprint-checker `fbc-iter041`**: see `recommendations.md §2`.

## Coverage debt (leandag `unmatched=4`)
4 prover-created helpers are `lean_aux` (no blueprint block): `image_basicOpen_of_affine`,
`compositeBasicOpenImmersion_image_basicOpen`, `image_basicOpen_eq_inf`, `section_localization_hfr_aux`.
Listed for the planner in `recommendations.md §1`. Plus 3 frontier blueprint blocks pin non-existent
`\lean{}` names (structure/rename mismatch — see §2).

## Manual blueprint markers this iter
See `summary.md` → "Blueprint markers updated (manual)".
