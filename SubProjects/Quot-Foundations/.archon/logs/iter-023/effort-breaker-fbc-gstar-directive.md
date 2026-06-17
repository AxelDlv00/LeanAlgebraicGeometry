# Effort Breaker Directive

## Slug
fbc-gstar

## Target
`lem:base_change_mate_gstar_transpose` (chapter `blueprint/src/chapters/Cohomology_FlatBaseChange.tex`, the lemma block at ~L1986 and its proof at ~L2048).

## Granularity
**fine — one mathematical claim per lemma.** A coarse 3-step break already exists in the proof prose (counit split / conjugate-counit coherence / generator close). Step 2 is still a ~150-LOC monolith that has blocked two consecutive prover iterations (iter-021, iter-022). Break step 2 (and step 3) into independently-formalizable named sub-lemmas, each small enough that its proof is a short, checkable move.

## Why this break is needed (do not re-state in the chapter; context only)
The most recent prover landed **step 1 (counit split) and the step-2 scaffold** (`adjL/adjR/β`, `hpullinv`, the `huce` master counit-transport identity via `conjugateEquiv_counit_symm`, and the `hcounitL/hcounitR` splits) — all compiling. What remains uncovered by the blueprint is the **inline derivation of `Γ_R(θ_in) = ρ`** (the inner-pushforward section reading equals the affine unit value `ρ : m ↦ (1⊗1)⊗m`) and the **generator close**. The lean-vs-blueprint-checker (iter-022) flagged the proof sketch as "under-specified at step 2": it asserts `Γ_R(θ_in) = ρ` "follows from the counit-triangle identity" but does not name the chain of already-proved atomic lemmas that actually establishes it. Your job is to turn that single under-specified sentence into a chain of `\uses`-linked sub-lemma blocks, each citing the concrete atoms.

## Proof structure (the seams to cut along)
The target proof, after the (already-formalized) counit split and `huce` scaffold, must establish two things, then combine them:

**Seam A — the inner value identity `Γ_R(θ_in) = ρ` (the ~150-LOC piece).**
`θ_in` is the inner pushforward comparison; reading it on `Spec R`-sections gives the canonical `R`-linear map `ρ : m ↦ (1⊗1)⊗m`. This is NOT to be cited from `lem:base_change_mate_fstar_reindex` (that lemma is sorry-backed via its dead `_legs` step-(iii) and is being retired). It must be re-derived **inline** from the standalone PROVED atoms. The derivation chain (these are existing, proved blocks in the same chapter — give each its accurate `\uses{}`):
  - `lem:base_change_mate_fstar_reindex_legs_unitExpand` — expands the `g'`-unit.
  - `lem:base_change_mate_fstar_reindex_legs_gammaDistribute` — distributes through `Γ`.
  - the three Γ-collapse atoms `lem:gammaMap_pushforwardComp_hom_eq_id`, `lem:gammaMap_pushforwardComp_inv_eq_id`, `lem:gammaMap_pushforwardCongr_hom` (these are `private` in Lean — see Notes).
  - `lem:pullbackPushforward_unit_comp` — the leg-reindex engine.
  - `lem:base_change_mate_unit_value` — Seam-1 value of the affine unit.
Break Seam A itself into the smallest sub-claims that fall out of these atoms (e.g. "unit expansion", "Γ-distribution", "transparent-coherence collapse", "leg-reindex", "assemble to ρ") — one sub-lemma per atom-application where that yields a checkable single move.

**Seam B — the generator close.**
`extendScalars ψ (ρ) ≫ ε^alg = (base_change_mate_regroupEquiv ψ φ M).inv`. Both sides are `R'`-linear; on the generator `r' ⊗ m` the LHS returns `(1 ⊗ r') ⊗ m`, which is exactly `regroupEquiv.inv` on that generator. This is a one-generator `ext` against the fully-proved `lem:base_change_mate_regroupEquiv`. State it as its own sub-lemma.

**Seam C — the dictionary cancellation (if it is a genuine separate step).**
Matching `huce`'s `pullback_spec_tilde_iso`/tilde-counit factors against the `Θ_src = lem:base_change_mate_domain_read` / `Θ_tgt = lem:base_change_mate_codomain_read` dictionaries baked into the goal. If this is more than a trivial rewrite, give it its own sub-lemma; otherwise fold it into the target's combining proof and note that in your report.

After authoring the chain, **rewrite the target's proof** to: (1) counit split [done content], (2) `huce` scaffold [done content], (3) invoke Seam-A sub-lemma(s) to rewrite `Γ_R(θ_in)` to `ρ`, (4) invoke Seam-B to close against `regroupEquiv.inv`. Update the target's `\uses{}` to list the new sub-lemmas plus the atoms they rest on. Keep the target's statement and `\lean{}` unchanged.

## Strategy context
This is the live crux of the **FBC-A** phase (affine base-change lemma, direct-on-sections, Stacks 02KH part 2). Closing `gstar_transpose` cascades to `base_change_mate_section_identity` → `base_change_mate_generator_trace` → `pushforward_base_change_mate_cancelBaseChange`, completing the affine section identity. It is the counit dual of the already-proved Seam-1 `base_change_mate_unit_value` (`analogies/fbc-mate.md`), so the chain you write mirrors Seam 1's structure on the counit side. The route is Mathlib-confirmed (`conjugateEquiv_counit_symm`, `Adjunction.comp_counit_app` both verified present); the gap is purely the missing sub-lemma decomposition of Seam A.

## References
- `references/stacks-coherent.md` → `references/stacks-coherent.tex` — Stacks "Cohomology of Schemes", Lemma "Affine base change" (tag 02KH), the "boils down to the equality `(R'⊗_R A)⊗_A M = R'⊗_R M`" step (around L933–938). This is the source for the target lemma; cite it on any NEW sub-lemma block that derives from it (the inner value / regroup identification). Read the local `.tex` and quote verbatim — do not write `% SOURCE QUOTE` from memory.
- `analogies/fbc-mate.md` and `analogies/fbc-conjugateequiv-counit-symm.md` — the conjugate-mate calculus (Seam 1 template + the counit dual). These are project analogy notes, not external sources; use for the proof shape, not for `% SOURCE` citation.

## Notes for you
- Three Γ-collapse atoms (`gammaMap_pushforwardComp_hom_eq_id`, `_inv_eq_id`, `gammaMap_pushforwardCongr_hom`) are `private` in the Lean file. The blueprint currently `\lean{}`-pins them by full name (technically unresolvable externally). When you `\uses{}` them, keep the existing labels; flag in your report that these stay `private` (their consumer is the same file, so it is fine) — this is a known minor, not your fix.
- Assign `\lean{}` names for the new sub-lemmas by convention (e.g. `AlgebraicGeometry.base_change_mate_inner_value_eq`, `AlgebraicGeometry.base_change_mate_gstar_generator_close`) and list them under "Notes for dispatcher" so I can confirm/scaffold them — the prover will create these decls.
- Do NOT touch `\leanok` anywhere. Do NOT retire/delete the dead `lem:base_change_mate_fstar_reindex` blocks — that is a separate refactor; just stop routing the target through them.
