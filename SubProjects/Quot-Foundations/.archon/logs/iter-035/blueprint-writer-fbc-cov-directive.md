# Blueprint-writer directive — FBC/FBCGlobal coverage debt + stale-pin cleanup (iter-035)

## Chapter
`blueprint/src/chapters/Cohomology_FlatBaseChange.tex` — CONSOLIDATED chapter, covers BOTH
`AlgebraicJacobian/Cohomology/FlatBaseChange.lean` AND `AlgebraicJacobian/Cohomology/FlatBaseChangeGlobal.lean`.

## Task A — FBCGlobal coverage debt (15 new blocks)
iter-034 landed the ModuleCat-over-A `eqLocus` sub-lane + payoff in `FlatBaseChangeGlobal.lean`, all
axiom-clean, but NONE have a blueprint block (isolated `lean_aux` nodes). Add one block per declaration
in a dedicated **FBC-B globalization** subsection (place it after the existing FBC-B / H⁰-equalizer
material; grep for `gamma_finite_equalizer_cover` or the FBC-B section heading to find the spot). All are
in namespace `AlgebraicGeometry`. These are project-bespoke algebra/sheaf bookkeeping — no external
SOURCE QUOTE required; a one-line internal justification each.

Declarations (exact Lean names) + intended role / `\uses`:
1. `groundRing` (def) — `A := X.presheaf.obj (op ⊤)`, the base CommRing. No deps.
2. `rhoU` (def) — restriction ring hom `A → Γ(X,U)`. `\uses{}` groundRing.
3. `rhoU_comp` (lemma) — transitivity of `rhoU` along `V ≤ U`. `\uses` rhoU.
4. `gammaModA` (def/abbrev) — `Γ(M,U)` as an A-module via `ModuleCat.restrictScalars (rhoU)`. `\uses` rhoU.
5. `gammaResAHom` (def) — A-linear restriction `gammaModA U → gammaModA V` (built via
   `restrictScalarsComp'App`). `\uses` gammaModA, rhoU_comp.
6. `gammaResA` (def) — the underlying A-linear map of (5). `\uses` gammaResAHom.
7. `gammaResA_apply` (lemma, `@[simp]`) — `gammaResA = M.val.map` on underlying functions. `\uses` gammaResA.
8. `gammaResA_comp` (lemma) — functoriality of `gammaResA`. `\uses` gammaResA, gammaResA_apply.
9. `leftRes` (def) — A-linear product leg `∏ᵢ Γ(M,Uᵢ) → ∏ᵢⱼ Γ(M,Uᵢⱼ)` (left restriction). `\uses` gammaResA.
10. `rightRes` (def) — the right restriction leg. `\uses` gammaResA.
11. `toCover` (def) — global-section restriction into `∏ᵢ Γ(M,Uᵢ)`. `\uses` gammaResA.
12. `leftRes_toCover` (lemma) — `leftRes ∘ toCover = rightRes ∘ toCover` (cocycle/compatibility). `\uses`
    leftRes, rightRes, toCover, gammaResA_comp.
13. `toCoverEqLocus` (def) — corestriction of `toCover` into `LinearMap.eqLocus leftRes rightRes`.
    `\uses` toCover, leftRes_toCover.
14. `gammaTopEquivEqLocus` (def/lemma) — **the keystone**: `Γ(M,⊤) ≃ₗ[A] eqLocus leftRes rightRes` for any
    cover with `iSup U = ⊤`, via `LinearEquiv.ofBijective`. `\uses` toCoverEqLocus, gammaModA, gammaResA,
    leftRes, rightRes. NOTE in the block: bijectivity is proved by the ELEMENT-LEVEL sheaf axioms
    (`TopCat.Sheaf.eq_of_locally_eq'` for injectivity, `TopCat.Sheaf.existsUnique_gluing'` for surjectivity)
    — it does NOT route through `Modules.gammaIsLimitSheafConditionFork`. Mark the two sheaf-axiom Mathlib
    facts as `\mathlibok` dependency anchors (state them in project notation with `\lean{}` pointing at the
    real Mathlib names `TopCat.Sheaf.eq_of_locally_eq'`, `TopCat.Sheaf.existsUnique_gluing'`).
15. `baseChangeGammaEquiv` (def/lemma) — **the payoff**: for any flat A-algebra B,
    `B ⊗_A Γ(M,⊤) ≃ₗ[B] eqLocus (lTensor B leftRes) (lTensor B rightRes)` — flat base change commutes with
    the H⁰ equalizer. `\uses` gammaTopEquivEqLocus + the existing `lem:flat_preserves_equalizer_mathlib`
    (`LinearMap.tensorEqLocusEquiv`, already `\mathlibok`). Grep the chapter for that label to confirm it.

## Task B — FBC-A conj-0 coverage debt (2 new blocks)
iter-034 landed the conjugate-route foundation in `FlatBaseChange.lean`. Add blocks (namespace
`AlgebraicGeometry`) near the Seam-2 conjugate-route material (grep `leftAdjointCompIso` / the conj-0
NOTE):
- `pullbackComp_inv_eq_leftAdjointCompIso_inv` (lemma) — `(pullbackComp f g).inv` equals the
  `leftAdjointCompIso`-of-`pushforwardComp` inverse. `\uses` the Mathlib `leftAdjointCompIso` /
  `conjugateEquiv_leftAdjointCompIso_inv` anchors + the project `conjugateEquiv_pullbackComp_inv`. One-line:
  both have the same image under `conjugateEquiv`, which is injective.
- `pullbackComp_eq_leftAdjointCompIso` (lemma) — the iso-level form, via `Iso.inv_eq_inv` + `Iso.ext`.
  `\uses` the inv-level block.
Wire `lem:base_change_mate_fstar_reindex_legs`'s `\uses` to include `pullbackComp_eq_leftAdjointCompIso`
(the conjugate route consumes it). Add a `\mathlibok` dependency anchor block for Mathlib's
`leftAdjointCompIso` (state it in project notation, `\lean{CategoryTheory.Adjunction.leftAdjointCompIso}` or
the exact name — verify via grep/search) so the route's reliance on Mathlib's `CompositionIso` calculus is
visible in the DAG.

## Task C — Stale `_link_*` pin cleanup (fixes a phantom frontier node)
The direct-on-sections route was ABANDONED (iter-033). Of its four `_link_*` lemmas, only
`base_change_mate_fstar_reindex_legs_link_distributeCollapse` STILL EXISTS in the Lean file (line ~1377);
the other three Lean decls were removed. But their blueprint blocks remain, with dangling `\lean{}` pins:
- `lem:base_change_mate_fstar_reindex_legs_link_cancelEUnit` (~L1844) — Lean decl GONE.
- `lem:base_change_mate_fstar_reindex_legs_link_cancelPullbackComp` (~L1885) — Lean decl GONE.
- `lem:base_change_mate_fstar_reindex_legs_link_survivor` (~L1922) — Lean decl GONE.
These three create phantom "ready-to-prove" frontier nodes. **Remove these three blocks** (statement +
proof) AND remove every `\uses{...}` reference to their three labels elsewhere in the chapter. KEEP
`lem:base_change_mate_fstar_reindex_legs_link_distributeCollapse` (~L1792) — its Lean decl still exists and
is used in the retained (abandoned-but-compiling) body. Add a one-line `% NOTE:` at the distributeCollapse
block recording that it is the sole surviving fragment of the abandoned direct-on-sections route, retained
because the current `_legs` body still references it.

## Constraints
- Do NOT add `\leanok` (deterministic sync owns it). You MAY add `\mathlibok` ONLY on the genuine Mathlib
  dependency anchors named in Tasks A.14 and B (`eq_of_locally_eq'`, `existsUnique_gluing'`,
  `tensorEqLocusEquiv` [already present], `leftAdjointCompIso`).
- Do NOT touch any other chapter, and do NOT touch the `_legs`/`gstar_transpose`/affine proof bodies —
  Task C only removes the three dead `_link_*` blocks and fixes `\uses` references to them.
- Grep to confirm exact existing labels before wiring `\uses`. If a needed label is absent, use a
  `% NOTE:` rather than inventing one.
- If you need a source you don't have, you may spawn a reference-retriever (references/** is in your
  write-domain) — but none should be needed (all blocks are project-bespoke).
