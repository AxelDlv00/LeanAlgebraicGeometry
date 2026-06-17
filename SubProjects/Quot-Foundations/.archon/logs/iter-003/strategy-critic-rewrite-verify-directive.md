# Strategy-critic directive — verify the rewritten Quot-Foundations strategy

You are a fresh-context critic. Read the strategy below as a working mathematician
would, with NO investment in the project's momentum. Challenge soundness and
goal-alignment of each route. The STRATEGY.md below was substantially rewritten in
the previous iteration (a QUOT-route challenge was addressed by rewriting the QUOT
section + adding the SNAP/GR-* decompositions) and has NOT been re-reviewed since.
Confirm the rewritten strategy is sound, or challenge it.

## Project goal (one paragraph)

Close the seven `sorry`-bearing nodes of the **Čech-independent leg** of the parent
project's `thm:fga_pic_representability` cone (Kleiman, "The Picard scheme", FGA;
Nitsure, "Construction of Hilbert and Quot Schemes", FGA Explained). The three target
clusters are: **FBC** — the i=0 flat base-change isomorphism
`g^* f_* F ⟶ f'_* g'^* F`; **GF** — generic flatness (`thm:generic_flatness` with
algebraic core `thm:generic_flatness_algebraic`); **QUOT** — `def:hilbert_polynomial`,
`def:quot_functor`, `def:grassmannian_scheme`, `thm:grassmannian_representable`.
End-state: zero project `sorry` in the cone, zero project axioms, kernel-only axioms.
Names/labels match the parent's so finished work merges back.

## Reference index (references/summary.md)

| File | Description |
| ---- | ----------- |
| nitsure-hilbert-quot | Nitsure, Hilbert/Quot schemes (arXiv:math/0504590). §1 Hilbert polynomial (Snapper), §2 Quot functor, §4 Generic Flatness (full induction proof), §5 Grassmannian + Quot construction. Primary source. |
| stacks-coherent | Stacks ch.30 Cohomology of Schemes — tag 02KH (flat base change of R^i f_*; H^0 part). Backs FBC. |
| stacks-schemes | Stacks Schemes ch — tag 01I9 (ψ* M̃ and ψ_* Ñ for affine ψ). Backs the tilde dictionaries. |
| stacks-constructions | Stacks ch.27 Constructions — relative-Spec tags. Backs Picard_RelativeSpec. |
| hartshorne-algebraic-geometry | Hartshorne AG (GTM 52). Background for Quot/Grassmannian, flat families, Hilbert polynomials. |

## Blueprint chapters (titles + one-line topic)

- Cohomology_FlatBaseChange.tex — Flat base change for pushforward of a QC sheaf (i=0); affine
  dictionaries (tilde ↔ restriction/extension of scalars), affine base-change lemma, H⁰-equalizer
  globalization.
- Picard_FlatteningStratification.tex — Generic flatness, algebraic + geometric form (Nitsure §4).
- Picard_QuotScheme.tex — The Quot scheme; Hilbert polynomial, Quot functor, Grassmannian, representability.
- Picard_RelativeSpec.tex — Relative Spec.

## STRATEGY.md (verbatim)

```
# Strategy

## Goal

Close the seven `sorry`-bearing nodes of the **Čech-independent leg** of the parent's
`thm:fga_pic_representability` cone (Kleiman FGA, "The Picard scheme", §4), then merge back:

- **FBC** — `lem:affine_base_change_pushforward` + `thm:flat_base_change_pushforward`
  (the i=0 base-change map `g^* f_* F ⟶ f'_* g'^* F` is an isomorphism).
- **GF** — `thm:generic_flatness` with algebraic core `thm:generic_flatness_algebraic`.
- **QUOT** — `def:hilbert_polynomial`, `def:quot_functor`, `def:grassmannian_scheme`,
  `thm:grassmannian_representable`.

End-state: zero project `sorry` in the 29-node closure, zero project axioms, kernel-only axioms.
Names/labels are the parent's so finished work merges back into its A.2.c engine.

## Phases & estimations

| Phase | Status | Iters left | LOC | Key Mathlib needs | Risks |
|---|---|---|---|---|---|
| FBC-A — affine lemma, direct-on-sections | ACTIVE | 3–5 | ~150–400 | proved tilde dictionaries (`pushforward/pullback_spec_tilde_iso`); `cancelBaseChange` | section-level identification of `pushforwardBaseChangeMap` with the canonical tensor iso may still carry coherence content |
| FBC-B — globalization, H⁰-equalizer | NEXT | 3–6 | ~150–350 | `Module.Flat.{ker,eqLocus}_lTensor_eq`; finite affine cover + sheaf condition for `SheafOfModules` | H⁰-as-equalizer infra for `SheafOfModules` may need building; qsep Mayer–Vietoris induction |
| GF-alg — algebraic core | ACTIVE | 2–4 | ~80–300 | `exists_free_localizedModule_powers`, `Module.freeLocus`, Noether normalisation | Mathlib-first survey collapses the finite-module case to a wrapper; only the polynomial-ring dévissage residue is hand-built |
| GF-geo — `genericFlatness` | NEXT | 1–2 | ~40–120 | algebraic core + affine-open reduction | needs `genericFlatness` re-signed with `[IsQuasicoherent]`+`[IsFiniteType]`; relating Γ(F,W) to a finite module over a finite-type algebra is real plumbing |
| QUOT-defs — Quot functor, Grassmannian defs + predicates | ACTIVE | 4–7 | ~250–600 | `Functor.IsRepresentable`, `Scheme.Modules.pullback`, `IsProper` | re-sign needs two project-side predicates absent at the pin (schematic-support/proper-support; rank-`r` local-freeness) built first; universe pin |
| SNAP — coherent-sheaf Euler char + Snapper polynomiality | BLOCKED | 4–8 | ~300–700 | `Polynomial.hilbertPoly`/`existsUnique_hilbertPoly` (building block); coherent cohomology finiteness | sheaf-cohomology χ for coherent sheaves is absent from Mathlib; gates `def:hilbert_polynomial` |
| QUOT-repr — `thm:grassmannian_representable` (4 sub-phases, see Routes) | BLOCKED | 6–12 | ~400–1000+ | Grassmannian-of-quotients as a scheme (absent); `RelativeSpec` strengthened to `RepresentableBy` | deepest target; decomposed into GR-cells/GR-glue/GR-quot/GR-repr in Routes |

## Routes

Single route per target; the leg is a fan of independent leaves merging back upstream.
Sequencing is bottom-up: FBC-A and GF-alg are the live frontier; QUOT is authorable in parallel
(all four files import only Mathlib). FBC-B follows FBC-A; GF-geo follows GF-alg; QUOT-repr follows
QUOT-defs, SNAP, and the RelativeSpec strengthening.

**FBC route.** Drop the parent's abstract adjoint-mate ↔ `cancelBaseChange` decomposition and the
deferred Mathlib `#37189` dependency. Prove the affine lemma **directly on global sections**:
rewrite both sides through the proved tilde dictionaries (`pullback_spec_tilde_iso`,
`pushforward_spec_tilde_iso`), reducing the affine base-change iso to the canonical
`(R'⊗_R A)⊗_A M ≅ R'⊗_R M` (Mathlib `cancelBaseChange`). Globalize the i=0 statement
**Čech-cohomology-free**: `H⁰(X,F)` is the equalizer `∏Γ(Uᵢ,F) ⇉ ∏Γ(Uᵢⱼ,F)` (sheaf condition,
Čech degree 0/1 — NOT Čech cohomology), and a flat `−⊗B` preserves that finite equalizer via
`Module.Flat.{ker,eqLocus}_lTensor_eq`. The affine-local reduction
`lem:base_change_map_affine_local` is now derived (naturality of the adjunction transpose +
pushforward-commutes-with-restriction), not asserted.

**GF route.** Algebraic core `genericFlatnessAlgebraic`: A noetherian domain, B finite-type
A-algebra, M finite B-module ⟹ ∃ f≠0, `M_f` free over `A_f`. Primary case (M finite over A) is a
thin wrapper over `exists_free_localizedModule_powers` at the generic point — already landed
axiom-clean in the `GenericFreeness` namespace. The surviving residue is the polynomial-ring
dévissage (M finite over a finite-type, not module-finite, A-algebra): Nitsure §4 prime-filtration
+ Noether normalisation, reducing to the primary case at the bottom; hand-built. Geometric form
`genericFlatness` (re-signed with coherence hyps) wraps the algebraic form by restricting to a
non-empty affine open Spec A ⊆ S and patching the basic opens D(f) over a finite affine cover of
X above Spec A.

**QUOT route.** Decisions taken to resolve the foundational dependencies:

- *Hilbert-polynomial encoding = cohomological χ.* `def:hilbert_polynomial` is the fiberwise Euler
  characteristic `Φ_s(m) = χ(X_s, F|_{X_s} ⊗ L_s^m)` (Nitsure §1), the invariant that is locally
  constant in flat families and indexes `def:quot_functor`. Mathlib's graded
  `Polynomial.hilbertPoly`/`existsUnique_hilbertPoly` (verified present) is NOT a substitute — it
  is the graded-module Hilbert–Serre polynomial, not the flat-family χ — but it IS a building block
  for the fiberwise polynomiality once χ is available. Sheaf-cohomology χ for coherent sheaves is
  verified absent from `Mathlib/AlgebraicGeometry/`, so it is the **SNAP** phase (its own
  decomposed gap), not a one-line risk note. SNAP sub-steps: (S1) finiteness of coherent
  cohomology on a proper scheme over a field → `χ : K_0` additive; (S2) Snapper/Kleiman
  polynomiality of `m ↦ χ(F ⊗ L^m)` (via S1 + graded `hilbertPoly` on the section ring).
- *QUOT-defs predicate sub-builds* (encoding-independent, do first): (P1) schematic-support closed
  subscheme of a coherent sheaf + `IsProper` ("proper support over S"); (P2) rank-`r`
  local-freeness predicate for `SheafOfModules` (`IsLocallyFree` is upstream-only / rank-agnostic
  at the pin). Both gate faithful re-signs of the four stubs. `Grassmannian := QuotFunctor (𝟙 S) V Φ_d`.
- *QUOT-repr decomposed* (replaces the 1000-LOC monolith): **GR-cells** — affine big cells
  `U^I ≅ A^{d(r-d)}_S` for each size-`d` index set `I` (~80–200 LOC); **GR-glue** — Plücker
  cocycle gluing of the cells into a scheme `Gr_S(V,d)` + separatedness via the diagonal
  (~150–350 LOC); **GR-quot** — tautological rank-`d` quotient `π*V ↠ U` + its universal property
  (~100–250 LOC); **GR-repr** — functor-of-points identification `Grass(V,d) ≅ Hom_S(−,Gr)` giving
  `RepresentableBy` (~100–250 LOC). GR-repr needs either `thm:relative_spec_univ` strengthened to a
  `RepresentableBy` witness or a transpose-free gluing argument (Open question).

## Open strategic questions

- RelativeSpec strengthening: `thm:relative_spec_univ` is proved only as `IsAffineHom`, not the
  `RepresentableBy` Yoneda form; `thm:relative_spec_affine_base` only as `IsAffine`, not the
  canonical iso `Spec_X(𝒜) ≅ Spec(Γ(X,𝒜))`. GR-repr needs the stronger forms. Decide: strengthen
  RelativeSpec (re-opens proved work) vs. a RepresentableBy-free GR-repr argument. Deferred —
  QUOT-repr is many iters out.
- Does FBC-A's direct-on-sections route fully dissolve the coherence wall, or does identifying
  `Γ(pushforwardBaseChangeMap)` with the canonical tensor iso still need a mate computation?
  Validate empirically once the affine lemma is attempted.

## Mathlib gaps & new material

Gaps to fill:
- FBC-B: H⁰-as-equalizer / finite-affine-cover sheaf-condition packaging for `SheafOfModules`.
- GF-alg: polynomial-ring generic-freeness residue not covered by `exists_free_localizedModule_powers`.
- SNAP: coherent-sheaf cohomology finiteness + Euler characteristic + Snapper polynomiality
  (graded `Polynomial.hilbertPoly` available as a building block).
- QUOT predicates: schematic-support/proper-support; rank-`r` local-freeness for `SheafOfModules`.
- QUOT-repr: Grassmannian-of-quotients as a scheme (Nitsure §1/§5 big-cell patching), per GR-* above.

New project material:
- `genericFlatnessAlgebraic` (new decl), re-signed `genericFlatness` (+`IsQuasicoherent`+`IsFiniteType`).
- Coherence encoding = `[IsQuasicoherent]` + `[IsFiniteType]` over the locally noetherian base
  (no single `IsCoherent` predicate at the pin), used uniformly across GF and QUOT re-signs.
- QUOT defs with tightened signatures (coherence on F/E, locally-free + rank on V, universe pin);
  `Grassmannian` via `QuotFunctor`; representability stated as `IsRepresentable`.

```

## What to assess

1. Is each route goal-aligned and sound at the statement level?
2. Is the QUOT rewrite (cohomological-χ Hilbert-polynomial encoding; SNAP phase for coherent-sheaf
   Euler characteristic + Snapper polynomiality; GR-cells/glue/quot/repr decomposition of the
   Grassmannian monolith) sound and faithful to Nitsure §1/§5?
3. Is the FBC direct-on-sections + H⁰-equalizer route (dropping the parent's abstract adjoint-mate
   ↔ cancelBaseChange decomposition and the Mathlib #37189 dependency) sound?
4. Is the GF route (thin-wrapper primary case over `exists_free_localizedModule_powers` + hand-built
   polynomial-ring dévissage residue) correctly scoped? Is anything over- or under-built?
5. Any structural planning error: hallucinated route, missing prerequisite, unnecessary case split,
   silent false assumption, sequencing error (a route that depends on something not yet built)?

Output your standard SOUND / CHALLENGE / REJECT verdict per route with concrete reasoning.
