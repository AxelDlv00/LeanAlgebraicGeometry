# Strategy Critic Directive

## Slug
iter002

## Project goal

Formalize the Čech-independent leg of the parent project's `thm:fga_pic_representability` cone
(FGA representability of the Picard scheme). Concretely, close seven `sorry`-bearing nodes with
zero project axioms, in three independent sub-legs: (FBC) the i=0 flat-base-change isomorphism
`g^* f_* F ⟶ f'_* g'^* F` for a quasi-coherent sheaf; (GF) generic flatness of a coherent sheaf
over a noetherian integral base (Nitsure §4), with its algebraic core; (QUOT) the Quot-scheme
foundations — Hilbert polynomial, Quot functor, Grassmannian, and Grassmannian representability.
Declaration names/labels match the parent so finished work merges back. No protected declarations
(`archon-protected.yaml` is empty).

## Strategy under review

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
| FBC-A — affine lemma, direct-on-sections | ACTIVE | 3–5 | ~150–400 | proved tilde dictionaries (`pushforward/pullback_spec_tilde_iso`); `cancelBaseChange` | section-level identification of `pushforwardBaseChangeMap` with the canonical tensor iso still carries real coherence content |
| FBC-B — globalization, H⁰-equalizer | NEXT | 3–6 | ~150–350 | `Module.Flat.{ker,eqLocus}_lTensor_eq` (`RingTheory/Flat/Equalizer`); finite affine cover + sheaf condition for `SheafOfModules` | H⁰-as-equalizer infra for `SheafOfModules` may itself need building; qsep Mayer–Vietoris induction |
| GF-alg — algebraic core | ACTIVE | 2–4 | ~80–300 | `Module.FinitePresentation.exists_free_localizedModule_powers`, `Module.freeLocus`, Noether normalisation | Mathlib-first survey may collapse §4 induction to a thin wrapper; only the surviving residue is hand-built |
| GF-geo — `genericFlatness` | NEXT | 1–2 | ~40–120 | algebraic core + affine-open reduction | needs `genericFlatness` re-signed with `[IsQuasicoherent]`+`[IsFiniteType]` (currently false as stated) |
| QUOT-defs — Hilbert poly, Quot functor, Grassmannian | ACTIVE | 5–9 | ~250–700 | `Functor.IsRepresentable`, `Scheme.Modules.pullback`, `Polynomial`, `IsProper`; Snapper χ infra (absent) | re-sign needs two project-side predicates absent at the pin (schematic-support/proper-support; rank-`r` local-freeness) built first; universe pin; Snapper polynomiality deep |
| QUOT-repr — `thm:grassmannian_representable` | BLOCKED | 6–12 | ~400–1000+ | Grassmannian-of-quotients as a scheme (absent); `RelativeSpec` strengthened to `RepresentableBy` | deepest single target; blocked on RelativeSpec Yoneda form (see Open questions) |

## Routes

Single route per target; the leg is a fan of independent leaves merging back upstream.
Sequencing is bottom-up: FBC-A and GF-alg are the live frontier; QUOT-defs are authorable in
parallel (all four files import only Mathlib). FBC-B follows FBC-A; GF-geo follows GF-alg;
QUOT-repr follows QUOT-defs and the RelativeSpec strengthening.

**FBC route (pivoted iter-001).** Drop the parent's abstract adjoint-mate ↔ `cancelBaseChange`
decomposition and the deferred Mathlib `#37189` dependency. Prove the affine lemma **directly on
global sections**: rewrite both sides through the already-proved tilde dictionaries
(`pullback_spec_tilde_iso`, `pushforward_spec_tilde_iso`), reducing the affine base-change iso to
the canonical `(R'⊗_R A)⊗_A M ≅ R'⊗_R M`. Globalize the i=0 statement **Čech-cohomology-free**:
`H⁰(X,F)` is the equalizer `∏Γ(Uᵢ,F) ⇉ ∏Γ(Uᵢⱼ,F)` (sheaf condition, Čech degree 0/1 — NOT Čech
cohomology), and a flat `−⊗B` preserves that finite equalizer via
`Module.Flat.{ker,eqLocus}_lTensor_eq`. This keeps the leg genuinely Čech-independent.

## Open strategic questions

- RelativeSpec strengthening: `thm:relative_spec_univ` is proved only as `IsAffineHom`, not the
  `RepresentableBy` Yoneda form; `thm:relative_spec_affine_base` only as `IsAffine`, not the
  canonical iso `Spec_X(𝒜) ≅ Spec(Γ(X,𝒜))`. QUOT-repr needs the stronger forms. Decide:
  strengthen RelativeSpec (re-opens proved work) vs. a RepresentableBy-free Grassmannian
  representability argument. Deferred — QUOT-repr is many iters out.
- Coherence encoding: "coherent" = `[IsQuasicoherent]` + `[IsFiniteType]` over the locally
  noetherian base (Mathlib has no single `IsCoherent` predicate at the pin). Confirm this is the
  encoding used uniformly in the re-signs of `genericFlatness` and the QUOT stubs.
- Does FBC-A's direct-on-sections route fully dissolve the coherence wall, or does identifying
  `Γ(pushforwardBaseChangeMap)` with the canonical tensor iso still need a mate computation?
  (Validate empirically once the affine lemma is attempted.)

## Mathlib gaps & new material

Gaps to fill:
- FBC-B: H⁰-as-equalizer / finite-affine-cover sheaf-condition packaging for `SheafOfModules`.
- GF-alg: polynomial-ring generic freeness residue not covered by `exists_free_localizedModule_powers`.
- QUOT: Grassmannian-of-quotients as a scheme (Nitsure §5 big-cell patching); Snapper χ polynomiality.

- QUOT (surfaced iter-001): schematic-support closed subscheme of a coherent sheaf +
  `IsProper` encoding for "proper support over S" (no clean Mathlib predicate at the pin);
  rank-`r` local-freeness predicate for `SheafOfModules` (`IsLocallyFree` is upstream-only and
  rank-agnostic at the pin). Both are project-side sub-builds required before the QUOT stubs can
  be re-signed faithfully.

New project material:
- `genericFlatnessAlgebraic` (new decl), re-signed `genericFlatness` (+`IsQuasicoherent`+`IsFiniteType`).
- QUOT defs with tightened signatures (coherence on F/E, locally-free + rank on V, universe pin);
  `Grassmannian` defined via `QuotFunctor`; representability stated as `IsRepresentable`.

## References index

| File | Description |
| ---- | ----------- |
| `nitsure-hilbert-quot.md` → pdf / src tex | Nitsure, "Construction of Hilbert and Quot Schemes" (FGA Explained). §1 Hilbert poly (Snapper), §2 Quot functor, §4 Lemma on Generic Flatness (backs `thm:generic_flatness_algebraic`), §5 Grassmannian + Quot construction. PRIMARY source. |
| `stacks-coherent.md` → tex | Stacks ch.30 Cohomology of Schemes — tag 02KH (flat base change of `R^i f_*`; part (2) H⁰-with-base-change). Backs FBC chapter. |
| `stacks-schemes.md` → tex | Stacks Schemes — tag 01I9 (`ψ* M̃`, `ψ_* Ñ` for affine ψ). Backs `lem:pullback_spec_tilde_iso`. |
| `stacks-constructions.md` → tex | Stacks ch.27 Constructions — relative-spectrum tags 01LL/01LO/01LQ/01LR/01LS. Backs Picard_RelativeSpec. |
| `hartshorne-algebraic-geometry.md` → pdf | Hartshorne AG (GTM 52). Background for Quot/Grassmannian (II.5, II.7, III.9). |

## Blueprint summary

- `Cohomology_FlatBaseChange.tex` — Flat base change for the pushforward of a quasi-coherent sheaf
  (i=0): affine base-change lemma via tilde dictionaries → `cancelBaseChange`, globalized
  Čech-free via the H⁰-equalizer / flat-tensor-preserves-equalizer.
- `Picard_RelativeSpec.tex` — Relative Spec: `Spec_X(𝒜)` construction and its universal property
  (proved as `IsAffineHom`/`IsAffine`; the `RepresentableBy`/canonical-iso strengthening deferred).
- `Picard_FlatteningStratification.tex` — Generic flatness (Nitsure §4): algebraic form (finite
  module over finite-type algebra over noetherian domain is generically free) + geometric form
  (coherent sheaf flat over a non-empty open of an integral noetherian base).
- `Picard_QuotScheme.tex` — Quot scheme foundations: Hilbert polynomial, Quot functor,
  Grassmannian (via QuotFunctor), Grassmannian representability.

## Prior critique status

- iter-001: FBC route used Čech cohomology / spectral sequences (Mathlib-absent) — addressed
  (route pivoted to direct-on-sections + H⁰-equalizer; recorded in STRATEGY ## Routes).
- iter-001: FBC affine close inherited parent's abstract mate ↔ `cancelBaseChange` wall + deferred
  `#37189` dependency — addressed (dropped; direct-on-sections route).
- iter-001: GF risk of over-building the full §4 induction — addressed (Mathlib-first survey,
  hand-build only the residue; recorded in GF-alg row).
- iter-001: `genericFlatness` signature false (no coherence hyp) — addressed (re-sign task recorded
  in GF-geo row + Open questions coherence-encoding bullet).
- iter-001: QUOT reinvented representability / under-typed stubs / broken cref — addressed
  (predicate sub-builds + `IsRepresentable` + universe pin recorded in QUOT rows + Mathlib gaps).
- iter-001: STRATEGY.md format NON-COMPLIANT — addressed (rewritten to canonical skeleton).
