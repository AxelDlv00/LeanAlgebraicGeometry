# Blueprint Writer Report

## Slug
fbc-route

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Cohomology_FlatBaseChange.tex

## Summary
Pivoted the chapter's two `sorry`-bearing nodes onto the Čech-independent
direct-on-sections route:
- the affine lemma `lem:affine_base_change_pushforward` now closes
  **directly on global sections** through the two proved tilde dictionaries +
  `cancelBaseChange`, not through an abstract adjoint-mate identification at the
  sheaf level;
- the global theorem `thm:flat_base_change_pushforward` now uses the **sheaf-condition
  equalizer** (Čech degree 0/1) + flat-preserves-finite-equalizer, with **no** Čech
  cohomology, Leray, or spectral sequence;
- added a `\mathlibok` anchor for the flat-preserves-equalizer input.

## Changes Made
- **Revised subsection intro** ("affine base-change lemma and its remaining
  obligations") — reframed the two obligations as *locality reduction* +
  *section-level identification* (was: base-change-of-the-map compatibility +
  abstract-mate-vs-concrete coherence). States the close is "locality on `S'`, then a
  pure computation on the module of global sections."
- **Revised** `lem:base_change_map_affine_local` (kept `\lean{AlgebraicGeometry.TODO.base_change_map_affine_local}`)
  — added the **exact intended Lean signature** in the prose body: ambient data
  `(f,g,f',g')`, `(h : IsPullback g' f' f g)` with `h.w : g' ≫ f = f' ≫ g`,
  hypotheses `[IsAffineHom f]`, `[F.IsQuasicoherent]`, conclusion the locality
  reduction `(∀ U : S'.affineOpens, IsIso ((pushforwardBaseChangeMap … F).app U)) →
  IsIso (pushforwardBaseChangeMap … F)`. Aligned its proof to the direct-on-sections
  framing (restriction commutes with the pullback/pushforward units & counits).
- **Revised** `lem:pushforward_base_change_mate_cancelBaseChange` (kept
  `\lean{AlgebraicGeometry.TODO.pushforward_base_change_mate_cancelBaseChange}`) —
  retitled to "Section-level value of the base-change map equals the cancellation
  isomorphism"; reframed as "Γ(α) **is** cancelBaseChange" (not "abstract mate equals
  cancelBaseChange"). Added the **exact intended Lean signature** (equality of
  `ModuleCat(R')`-morphisms `Θ_tgt ∘ Γ(pushforwardBaseChangeMap …) ∘ Θ_src⁻¹ =
  cancelBaseChange⁻¹`) and a full **element-level proof sketch** in 4 steps tracing a
  generator `(r'⊗a)⊗m` / `r'⊗m` through: the `((g')^*,(g')_*)`-unit `m ↦ 1⊗m`, the
  `f_* = restr_φ` reading + pseudofunctor identifications `(g'f)_* = (f'g)_* = g_*f'_*`,
  the `(g^*,g_*)`-transpose/counit for `ψ` (giving `r'⊗m ↦ (r'⊗1)⊗m`), landing on
  `cancelBaseChange`. Each adjunction unit/counit is named at its step.
- **Rewrote the proof of** `lem:affine_base_change_pushforward` — now a clean composite
  of the two obligations (locality reduction → passage to global sections via tilde
  full-faithfulness → section-level identification with `cancelBaseChange`). Removed
  the old "crux of the remaining Lean work is to match the abstract adjoint mate"
  language. Replaced the stale iteration-history NOTE comment with a history-free one.
- **Added** `\mathlibok` anchor `lem:flat_preserves_equalizer_mathlib`
  `\lean{LinearMap.tensorEqLocusEquiv}` — "Flat base change preserves finite
  equalizers": `B ⊗_A eq(f,g) ≅ eq(1⊗f, 1⊗g)`. Notes the kernel special case
  (`LinearMap.tensorKerEquiv`) and the underlying range identities
  `Module.Flat.ker_lTensor_eq` / `Module.Flat.eqLocus_lTensor_eq`. All four names
  verified to exist in `Mathlib/RingTheory/Flat/Equalizer.lean`.
- **Rewrote the proof of** `thm:flat_base_change_pushforward` — Čech-FREE `i=0` route:
  (1) local on `S'` → `S=Spec A`, `S'=Spec B`, `A→B` flat; (2) `H⁰(X,F) = Γ(X,F)` as
  the **sheaf-condition equalizer** `∏ᵢ Γ(Uᵢ,F) ⇉ ∏ᵢⱼ Γ(Uᵢⱼ,F)`; (3) separated case:
  intersections affine, each term `⊗_A B` by the affine lemma; (4) flat preserves the
  finite equalizer via `lem:flat_preserves_equalizer_mathlib`; (5) quasi-separated
  case by **Mayer–Vietoris induction on `t`** (base case affine; new intersection
  terms separated+quasi-compact, handled by the separated case; flat preserves the
  two-member equalizer). Removed all spectral-sequence / Čech-to-cohomology language.
  Extended the `% SOURCE QUOTE PROOF:` verbatim block to include the source's
  quasi-separated/Mayer–Vietoris paragraph (now backing the chosen route), and
  replaced the stale Čech-infrastructure NOTE.

## Cross-references introduced
- `thm:flat_base_change_pushforward` `\uses{}` now adds `lem:flat_preserves_equalizer_mathlib`
  (new anchor, this chapter). Verified present.
- Proof prose `\ref`s (not `\uses` edges, as they are parallel obligations not logical
  dependencies): `lem:base_change_map_affine_local` and
  `lem:pushforward_base_change_mate_cancelBaseChange` cross-reference each other and the
  affine lemma. All labels verified to exist via `leandag` (`unknown_uses: []`).

## Verification
- `leandag build --json`: `unknown_uses: []`, `conflicts: []`; `mathlib_ok` rose to `2`
  (new anchor counted); `isolated: 4` are all `lean_aux` nodes — none of my blueprint
  nodes are isolated. `unmatched_lean` lists the two `TODO.*` decls (intentionally not
  scaffolded yet) and `LinearMap.tensorEqLocusEquiv` (a Mathlib decl, not in the
  project Lean scan — same situation as the existing `lem:functor_is_representable_mathlib`
  anchor); these are expected, not errors.
- LaTeX: `lemma`/`theorem`/`proof`/`array` environments balanced; display math `\[…\]`
  balanced (31/31); inline `\(…\)` balanced (757/757). No literal `REF`, no interleaved
  `$…\(…\)…$`, no project-history prose. Added **no** `\leanok` (left the pre-existing
  ones on the two statement blocks untouched). Exactly one `\mathlibok`, on the anchor.

## References consulted
- `references/stacks-coherent.tex` (Tag/Lemma `lemma-affine-base-change`, L906–938;
  `lemma-flat-base-change-cohomology` = Tag 02KH, L947–1050) — verbatim
  `% SOURCE QUOTE` / `% SOURCE QUOTE PROOF` for the affine lemma, the two obligations,
  and the flat-base-change theorem (including the Mayer–Vietoris-on-`t` sentence now
  added to the theorem's proof quote).
- `references/stacks-schemes.tex` (Tag 01I9, `lemma-widetilde-pullback`, L1241–1256) —
  the existing pullback-dictionary citation (`lem:pullback_spec_tilde_iso`); read to
  confirm it was not disturbed.
- Mathlib (read directly from `.lake/packages/mathlib`, for `\lean{}` / `\mathlibok`
  fidelity, not for `% SOURCE` quotes):
  `Mathlib/RingTheory/Flat/Equalizer.lean` (`Module.Flat.ker_lTensor_eq`,
  `Module.Flat.eqLocus_lTensor_eq`, `LinearMap.tensorKerEquiv`,
  `LinearMap.tensorEqLocusEquiv`); `Mathlib/LinearAlgebra/TensorProduct/Tower.lean`
  (`…AlgebraTensorModule.cancelBaseChange`, `cancelBaseChange_tmul`); and
  `AlgebraicJacobian/Cohomology/FlatBaseChange.lean` (project Lean signatures of
  `pushforwardBaseChangeMap`, `affineBaseChange_pushforward_iso`,
  `flatBaseChange_pushforward_isIso`, and the `variable` context).

## Macros needed
- None. `\mathlibok` already defined in `blueprint/src/macros/print.tex`.

## Reference-retriever dispatches
- None. All required sources were already on disk.

## Notes for Plan Agent
- **Mathlib `cancelBaseChange` orientation.** The directive presents `cancelBaseChange`
  as `(R'⊗_R A)⊗_A M → R'⊗_R M`, `(r'⊗a)⊗m ↦ r'⊗(a·m)`, and asks that `Γ(α)` "equal
  cancelBaseChange." Tracing the actual base-change map `α : g^*(f_*F) → f'_*((g')^*F)`
  shows `Γ(α)` runs `R'⊗_R M → (R'⊗_R A)⊗_A M`, `r'⊗m ↦ (r'⊗1)⊗m`, i.e. `Γ(α) =
  cancelBaseChange⁻¹` (`cancelBaseChange`'s **inverse**), an iso either way. The prose
  states this explicitly so the scaffold/prover is not misled into the wrong direction.
  Mathlib's decl is `TensorProduct.AlgebraTensorModule.cancelBaseChange :
  M ⊗[A] (A ⊗[R] N) ≃ₗ[B] M ⊗[R] N` with `cancelBaseChange_tmul : m ⊗ₜ (a ⊗ₜ n) =
  (a • m) ⊗ₜ n` — the prover will need to fix which Mathlib argument slot (`R',A,M`)
  maps to which, plus the algebra iso `(R'⊗_R A)` as base-changed `A`-algebra; flagged
  so the scaffold pass states the helper's conclusion in the orientation it can prove.
- **Anchor `\lean{}` target.** I chose `LinearMap.tensorEqLocusEquiv` (the packaged
  flat equalizer iso) over the directive's named `Module.Flat.eqLocus_lTensor_eq` (a
  `range` identity), because the equiv is the directly-usable "flat preserves the
  equalizer" statement; both, plus `ker_lTensor_eq` and `tensorKerEquiv`, are named in
  the anchor body. If the prover prefers to wire the theorem through the bare
  `eqLocus_lTensor_eq` range identity, the `\lean{}` can be repinned — both exist.
- The two `TODO.*` Lean decls are intentionally unbuilt; the chapter now carries their
  exact intended signatures for a faithful scaffold pass.

## Strategy-modifying findings
None. The pivot is internal to this chapter's route and is fully supported by the
existing Stacks sources and the verified Mathlib `Flat/Equalizer` + `cancelBaseChange`
declarations. The `i=0` case genuinely needs only the sheaf-condition equalizer (not
Čech cohomology), consistent with the leg's "Čech-independent" billing.
