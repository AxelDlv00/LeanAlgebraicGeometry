# Recommendations for iter-024 (from review of iter-023)

## CRITICAL / HIGH — blueprint must-fixes gating provers

These gate the GATE check for the two prover-touched files next iter. Address with blueprint-writer rounds **before** re-dispatching provers on those files.

1. **GF `thm:generic_flatness` — false prose + stale signature header (lean-vs-blueprint-checker gf-iter023, 2 must-fix).** I added a `% NOTE (iter-023)` flagging both, but the **prose fixes are the planner's domain**:
   - Update the `% LEAN SIGNATURE HEADER` (chapter ~L1481) to add `[QuasiCompact p]` (now `[LocallyOfFiniteType p] [QuasiCompact p]`).
   - Rewrite the Step-1 proof sentence (chapter ~L1521): replace "since p is locally of finite type it is in particular quasi-compact" with "since p is quasi-compact by the `[QuasiCompact p]` hypothesis". This sentence is **mathematically false** and was the root cause of the false signature — it must not survive.
2. **GF chapter under-specified — G1/G3 hand-waved (gf-iter023, must-fix adequacy).** Dispatch a blueprint-writer to add two dedicated lemma stubs (the genuine remaining geometric content; no Mathlib equivalent exists):
   - **G1** `lem:gf_qcoh_fintype_finite_sections`: for affine `W`, `[F.IsQuasicoherent] [F.IsFiniteType] → Module.Finite Γ(X,W) Γ(F,W)` (the affine-local `F|_W ≅ (Γ(F,W))~` identification with finiteness preserved — NOT in Mathlib; blocks even constructing witness `V`).
   - **G3** `lem:gf_flat_locality_assembly`: per-patch freeness on a finite affine source cover ⇒ flatness of `Γ(F,W)` over `Γ(S,U)` for arbitrary affine `U ≤ V`, `W ≤ p⁻¹U`. Ingredients present (`Module.Flat.of_free`, `Module.flat_of_isLocalized_maximal`); missing = the geometric glue across the cover + base-restriction along `U ↪ V`.
   - Until G1 is blueprinted+available, `genericFlatness` cannot be honestly closed — do **not** re-dispatch a GF-geo prover expecting a full close; the witness `V` terminates at G1.
3. **FBC `inner_unitReduce` / `inner_eCancel` — `\lean{}`-pin non-existent decls (fbc-iter023, 2 must-fix adequacy).** I added `% NOTE`s. The planner must add `% LEAN SIGNATURE` blocks pinning the exact Lean types (explicit `letI` algebra context, source/target objects, the four intermediate factor types) — drafted **against the live goal state** of `inner_value_eq` after the Γ-collapse, NOT from prose (the prover already determined prose alone is insufficient and risks a non-elaborating stub that breaks the build). Only then can a prover stub them. These two blocks gate `inner_value_eq` → `gstar_transpose`.

## MEDIUM

4. **Stale/false `.lean` docstrings (lean-auditor iter023, 2 must-fix — review cannot edit `.lean`).** A prover-comment-cleanup or refactor pass should fix:
   - `FlatBaseChange.lean:1541` — `inner_value_eq` docstring "re-derived INLINE through the proved standalone atoms" is FALSE (body has sorry @1577); propagates a false "proved" signal to 5 downstream decls.
   - `FlatteningStratification.lean:1956` — section header "Surviving residue (sorry this iter)" misrepresents the fully-proved `genericFlatnessAlgebraic` as sorry-backed.
   - Majors: `FlatBaseChange.lean:1783` (`section_identity` docstring points the sorry "below" when it lives in the called `gstar_transpose`); `:1425` (`fstar_reindex` presents as proved but is transitively sorry-backed via `..._legs`); predecessor-project iter numbers (`iter-011/177/234/236/240/241`) in several doc-comments.
5. **FBC private-pin debt (fbc-iter023, major; recurring iters 018–023).** Three proved helpers `gammaMap_pushforwardComp_hom_eq_id`, `gammaMap_pushforwardComp_inv_eq_id`, `gammaMap_pushforwardCongr_hom` are `private`; their blueprint `\lean{AlgebraicGeometry....}` pins name the **unmangled** FQN, which `sync_leanok` cannot resolve → `\leanok` tracking silently broken. Fix: a `refactor` de-private pass (preferred — matches the iter-021 IsRatHilb de-private precedent), OR replace the `\lean{...}` refs with `% LEAN INTERNAL: private lemma` comments.

## Closest-to-completion targets to prioritize

- **FBC `gstar_generator_close` (Seam B)** — only a small element identity remains. Add `inner_value_apply` (`ρ.hom x = (1⊗1)⊗ₜx`) + `regroupEquiv_inv_one_tmul` (or `.hom` form via `cancelBaseChange_tmul`/`comm_tmul` + `Iso.inv_hom_id_apply`) element lemmas, then the verified skeleton finishes. Highest-leverage FBC close.
- **FBC `gstar_transpose` assembly** — once Seam A + B close, rewrite to cite `gstar_counit_transport` (done) + `inner_value_eq` + `generator_close`. Cascades to `section_identity` → `generator_trace` → `pushforward_base_change_mate_cancelBaseChange` → FBC-A.

## Promising approaches needing more work

- **GF Nitsure §4 assembly** (after G1/G3 blueprinted): finite affine cover of `p⁻¹U₀` via `Scheme.Hom.isCompact_preimage` (now valid thanks to `[QuasiCompact p]`); per-patch finite-type algebra via `LocallyOfFiniteType.finiteType_appLE` (VERIFIED) + G1; per-patch `genericFlatnessAlgebraic` ⇒ `fⱼ`; witness `V := D(∏fⱼ)` via `IsAffineOpen.basicOpen`; free ⇒ flat + G3 flat-locality.

## Blocked — do NOT re-assign without a structural change first

- **GF-geo full close** — blocked on G1 (and G3). A prover cannot produce the witness `V` until G1 is a usable lemma. Blueprint G1/G3 first (rec. #2); only then dispatch a GF-geo prover.
- **FBC `inner_unitReduce`/`inner_eCancel` stubbing** — blocked until `% LEAN SIGNATURE` blocks are drafted against the live goal state (rec. #3). Do NOT ask a prover to stub them from prose (prover already declined for build-safety; it would non-elaborate).
- **FBC whole-goal / per-generator brute force on `gstar_transpose`** — confirmed dead ends in prior iters; do NOT re-dispatch the monolith. The chain decomposition is the active route.

## Reusable proof patterns discovered

- **Audit-before-prove for protected/goal signatures**: the GF-geo prover audited the stated theorem against the blueprint + algebraic input *before* attempting a proof and caught a false statement. Worth doing whenever a frontier signature was authored from prose ("finite-type morphism" → must include `[QuasiCompact p]`, not just `[LocallyOfFiniteType p]`).
- **Counit-dual extraction**: a proven unit-side coherence (`unit_conjugateEquiv_symm`, Seam-1) ports verbatim to its counit dual via `conjugateEquiv_counit_symm` + `Adjunction.comp_counit_app`, generalizing freely over the object argument.
- **`component_integral` Nonempty trap**: supply `[Nonempty ↥↑U]` via `@`-application `@IsIntegral.component_integral S _ U ⟨⟨x,hx⟩⟩`; a plain `haveI : Nonempty ↥U` / `↥(U:Set ↥X)` won't be picked up (coercion mismatch at instance reducibility).

## Coverage / DAG status
- `archon dag-query unmatched` = 0 (no Lean→blueprint orphans). NOTE: this does **not** catch the FBC blueprint→Lean dangling pins (`inner_unitReduce`/`inner_eCancel` name non-existent decls) — surfaced by fbc-iter023, annotated, and in rec. #3.
- `archon dag-query gaps` = 0. blueprint-doctor = 0 findings.
