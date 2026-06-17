# Recommendations for iter-023 (from review of iter-022)

## HIGH — gate items / must-fix-this-iter

1. **FBC blueprint-adequacy GATE (blocks the next FBC prover).** `lean-vs-blueprint-checker-fbc-iter022` flags `lem:base_change_mate_gstar_transpose`'s proof sketch as **under-specified at step 2**: it does not describe the inline derivation of `Γ_R(θ_in) = ρ` (the genuine ~150-LOC telescoping). **Action**: dispatch a **blueprint-writer** (or **effort-breaker**) on `lem:base_change_mate_gstar_transpose` to expand step 2 — explicitly directing the prover to reproduce `Γ_R(θ_in) = ρ` INLINE from `base_change_mate_fstar_reindex_legs_unitExpand`, `…_legs_gammaDistribute`, the three Γ-collapse atoms, `pullbackPushforward_unit_comp`, and Seam-1 `base_change_mate_unit_value` (NOT via the sorry-backed `base_change_mate_fstar_reindex`). Do this BEFORE any FBC prover. Per the HARD GATE, FBC stays deferred until a scoped re-review clears the chapter.
   - The step-1 conjugate-counit scaffold is landed + compiling; the prover next needs the trap-aware `ε_g` rewrite (use `conv`/`change`, not bare `rw`; `set W` does not fold the counit-app object). **Do NOT** re-dispatch whole-goal or per-generator brute force — both confirmed dead ends.

## MEDIUM

2. **Stale Lean comments (need a prover/refactor pass — review agent cannot edit `.lean`).** Two `major` stale comments confirmed by both auditors:
   - `FlatBaseChange.lean` @235–247: describes a `pushforward_spec_tilde_iso` QC-route obligation that is resolved via the localization route.
   - `FlatteningStratification.lean` @1956–1963: `/-!` section docstring still reads "Surviving residue (`sorry` this iter)" though `genericFlatnessAlgebraic` is now fully proved. Update to reflect the closed state.
   - Cheapest: fold these into whichever prover/refactor next touches each file (the FBC step-2 prover can fix the FBC one; a small GF cleanup can fix the GF one).

3. **`private`-pinned FBC helpers (recurring debt).** `gammaMap_pushforwardComp_hom_eq_id`, `gammaMap_pushforwardComp_inv_eq_id`, `gammaMap_pushforwardCongr_hom` are `private` in `FlatBaseChange.lean` but the chapter `\lean{}`-pins them by full name → invisible to `sync_leanok`/external tools. Same class as the prior-iter GF Nagata `private` debt. Dispatch a **refactor** de-`private` pass when FBC is next opened (combine with the step-2 prover round).

4. **GF lane next target.** GF algebraic route is DONE (`genericFlatnessAlgebraic` axiom-clean). The only GF `sorry` is geometric `genericFlatness` @2208, which owes a **finite-affine-cover chapter section** first (blueprint-writer, then prove). This is the natural GF frontier for iter-023+.

## LOW / infra

5. **sync_leanok GF-chapter resolution failure — now SYSTEMIC (flagged iter-021, persists iter-022).** sync ran (`iter:22, sha:7e2ae05, added:0, removed:0, chapters_touched:[]`) yet `Picard_FlatteningStratification.tex` carries **0 `\leanok` across 43 `\lean{}` pins**, even though `genericFlatnessAlgebraic` (public, @1981) and `exists_localizationAway_finite_mvPolynomial` (public) are both `sorry`-free + axiom-clean and correctly listed in `blueprint/lean_decls`. The all-or-nothing 0/43 pattern + the project's known `lake env lean` single-file instance-diamond pathology (see memory `lake-build-vs-env-lean-spurious-errors`) strongly suggest **sync_leanok checks via single-file `lake env lean`, which spuriously fails this file → no decl in the chapter is marked ok**. Surface to the user: have sync verify with `lake build`-based status (or whitelist this file), else the dashboard permanently under-reports GF as 0% done. This is not in-loop fixable by the planner/prover.

## Do NOT re-assign
- `base_change_mate_fstar_reindex` / `…_legs` — dead code (route swapped iter-020). The gstar route reproves `Γ_R(θ_in)=ρ` inline; do not try to fix the orphaned apparatus.
- FBC `gstar_transpose` whole-goal `ext` / per-generator brute force — confirmed dead ends.
- GF hand-built composite `Algebra A Cg` in the bridge — DIAMOND, isDefEq blowup; ambient `inferInstance` only.

## Reusable proof patterns discovered
- **Ambient-instance discipline** in deep localisation/quotient stacks (avoid hand-built composite `Algebra`/`IsScalarTower` diamonds).
- **Strengthen-the-existential**: add a compatibility conjunct to pin an instance the existential would otherwise erase (L4 4th conjunct → unblocked the genericFlatnessAlgebraic bridge).
- **Conjugate-counit dual** of a proven unit lemma transfers verbatim (Seam-1 → gstar step 1), incl. the `.symm β.hom = …inv` direction.
