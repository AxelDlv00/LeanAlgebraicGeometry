# Strategy critique — fresh-context audit (Quot-Foundations, iter 001)

You are a fresh mathematician with no stake in this project's history. Challenge the
strategy below on its mathematical and structural merits.

## Project goal (one paragraph)

Quot-Foundations is the **Čech-independent leg** carved from a parent project that aims
at `thm:fga_pic_representability` (Kleiman FGA, "The Picard scheme", §4). This leg must
close seven `sorry`-bearing declarations in a 29-node dependency closure, then merge back
into the parent: (FBC) flat base change of the pushforward in the i=0 case —
`thm:flat_base_change_pushforward` and its affine lemma `lem:affine_base_change_pushforward`;
(GF) generic flatness `thm:generic_flatness` with algebraic core
`thm:generic_flatness_algebraic`; (QUOT) the Hilbert polynomial `def:hilbert_polynomial`,
Quot functor `def:quot_functor`, Grassmannian scheme `def:grassmannian_scheme`, and its
representability `thm:grassmannian_representable`. End-state: zero project `sorry`, zero
project axioms.

## STRATEGY.md (verbatim)

```
# Strategy

## Goal

Close the seven sorry-bearing nodes of the **Čech-independent leg** of the parent project's
`thm:fga_pic_representability` cone (Kleiman FGA, "The Picard scheme", §4 main theorem):

- **FBC** — `thm:flat_base_change_pushforward` + `lem:affine_base_change_pushforward`:
  for flat `g`, the base-change map `g^* f_* F ⟶ f'_* g'^* F` is an isomorphism (i = 0).
- **GF** — `thm:generic_flatness` (with its algebraic core `thm:generic_flatness_algebraic`).
- **QUOT** — `def:hilbert_polynomial`, `def:quot_functor`, `def:grassmannian_scheme`,
  `thm:grassmannian_representable`.

End-state: zero inline `sorry` in the 29-node closure, 0 project axioms, kernel-only axioms.
All names/labels are the parent's; finished work merges back into the parent's A.2.c engine,
where `thm:quot_representable` and the flattening stratification build directly on these.

## Phases & estimations

| Phase | Status | Key references | Risks |
|---|---|---|---|
| FBC — affine close + globalization | OPEN; 16/18 chapter nodes already proved, only the two target nodes left | Stacks **02KH**; Stacks **01I9** (`ψ^* M̃`, backing the proved `lem:pullback_spec_tilde_iso`) | parent flagged a defeq wall here (iter-243, "Mathlib-scale"); the parent-side unstick notes: `algebraize [φ.hom]` scalar transport, alignment with `isIso_fromTildeΓ_pushforward`, deferred `#37189` bump |
| GF — generic flatness | OPEN; Nitsure §4 proof fully transcribed in the blueprint | [Nitsure] §4 (src L1711–1772); Mathlib `Module.Flat`, Noether normalisation | algebraic core may be Mathlib-scale if the prime-filtration induction has no Mathlib substrate; `GenericFreeness` namespace supplements already in-file |
| QUOT — foundations defs + Grassmannian representability | OPEN; 4 stubs with typed signatures | [Nitsure] §1 (Hilbert poly/Snapper), §2 (Quot functor), §5 (Grassmannian, Quot construction); kept RelativeSpec nodes (`thm:relative_spec_exists/univ/affine_base`) as substrate | these are DEFINITIONS consumed by the parent's `thm:quot_representable` — wrong design = merge-back rework; anchor every choice in Nitsure |

## Routes

Bottom-up per the parent's standing directive: FBC and GF are leaves; QUOT's definitions can be
authored in parallel (all four files import only Mathlib — no cross-lane imports). The
Grassmannian representability proof (Nitsure §5: open cover by big cells / standard opens)
should follow the definition within the same lane.

## Out of scope (lives in the parent or the sibling Čech subproject)

- Čech cohomology, higher direct images `Rⁱf_*` (i ≥ 1), `thm:flat_base_change_higher` —
  sibling Čech leg + parent.
- `thm:quot_representable`, flattening stratification existence/universality, the FGA
  representability assembly, everything Picard/Jacobian — parent.
- Riemann–Roch remains permanently paused (parent USER directive); nothing here touches it.

## Mathlib gaps & new material

- FBC affine close: see the parent unstick notes above (the one previously-flagged hard point
  of this package).
- GF algebraic core: check Mathlib for generic freeness / Noether normalisation before
  hand-building the prime-filtration induction.
- QUOT: Grassmannian-of-quotients as a scheme is absent from Mathlib; Nitsure §5's
  construction (patching big cells) is the blueprint route.
```

## Reference index (references/summary.md)

```
# References

<!-- archon:references-summary -->

| File | Description |
| ---- | ----------- |
| [`nitsure-hilbert-quot.md`](./nitsure-hilbert-quot.md) → `nitsure-hilbert-quot.pdf` / `-src/*.tex` | Nitsure, "Construction of Hilbert and Quot Schemes" (FGA Explained / arXiv:math/0504590). **The primary source for this subproject.** §1 Hilbert polynomial (Snapper), §2 the Quot functor, **§4 "Lemma on Generic Flatness"** (full induction proof, src L1711–1772 — backs `thm:generic_flatness_algebraic`), §5 Grassmannian + Quot construction (backs `def:grassmannian_scheme` / `thm:grassmannian_representable`). |
| [`stacks-coherent.md`](./stacks-coherent.md) → `stacks-coherent.tex` | Stacks ch.30 "Cohomology of Schemes" — tag **02KH** (flat base change of `R^i f_*`; part (2) `H^0`-with-base-change). Backs `thm:flat_base_change_pushforward` / `lem:affine_base_change_pushforward` in `Cohomology_FlatBaseChange.tex`. |
| [`stacks-schemes.md`](./stacks-schemes.md) → `stacks-schemes.tex` | Stacks ch. "Schemes" (tag 020J) — **tag 01I9** = `lemma-widetilde-pullback` (§7 "Quasi-coherent sheaves on affines", line 1242): `ψ* M̃ = (S⊗_R M)~` and `ψ_* Ñ = (N_R)~` for affine `ψ: Spec(S)→Spec(R)`. Direct source for the proved `lem:pullback_spec_tilde_iso` in `Cohomology_FlatBaseChange.tex`. |
| [`stacks-constructions.md`](./stacks-constructions.md) → `stacks-constructions.tex` | Stacks ch.27 "Constructions of Schemes" — tags **01LL**/**01LO**/**01LQ**/**01LR**/**01LS** (relative-spectrum chapter: situation, glueing, functor `F`, base change). **Caveat**: 01LL is a SECTION label, 01LO is the transitivity (NOT affine-case) lemma, 01LR is the eqn defining `F`. Adjacent tags **01LM**, **01LP**, **01LT** (the affine base case) are the likely real quote targets — see pointer file caveats. Backs `Picard_RelativeSpec.tex`. |
| [`hartshorne-algebraic-geometry.md`](./hartshorne-algebraic-geometry.md) → `hartshorne-algebraic-geometry.pdf` | Hartshorne, "Algebraic Geometry" (GTM 52, 1977). Background companion for the Quot/Grassmannian chapter (II.§5 quasi-coherent sheaves, II.§7 Grassmannians/projective morphisms, III.§9 flat families & Hilbert polynomials). Offset +17 (body). Scanned image PDF. |
```

## Blueprint chapter summary (titles + one-line topic)

- `Cohomology_FlatBaseChange.tex` — "Flat base change for the pushforward of a quasi-coherent
  sheaf (i=0)"; affine dictionaries (pushforward/pullback of a tilde-module) all proved, the
  affine base-change lemma + its qcqs globalization remain sorry. Stacks Tag 02KH / 01I9.
- `Picard_RelativeSpec.tex` — "Relative Spec"; supporting affine-construction nodes, all proved.
- `Picard_FlatteningStratification.tex` — "Flattening Stratification of a Coherent Sheaf";
  generic flatness (Nitsure §4 induction), finite-module case proved, full algebraic core sorry.
- `Picard_QuotScheme.tex` — "The Quot scheme"; Hilbert polynomial (Snapper), Quot functor,
  Grassmannian scheme + representability (Nitsure §1,§2,§5). Four definition/theorem stubs.

## Questions I specifically want challenged

1. **Scope coherence of FBC.** `thm:flat_base_change_pushforward`'s blueprint proof uses
   Čech-cohomology / affine-cover infrastructure for `SheafOfModules`. But this leg is billed
   "Čech-independent" and the strategy's Out-of-scope section excises Čech cohomology to the
   sibling leg. Is closing `thm:flat_base_change_pushforward` actually in reach here? Is there
   a Čech-free i=0 route (H⁰ as a finite limit that flat `-⊗B` preserves), or should this target
   be re-scoped / deferred to the parent and only the affine lemma kept here?
2. **FBC affine close difficulty.** The two remaining affine obligations (affine-reduction
   naturality of the base-change map; adjoint-mate ↔ `cancelBaseChange` coherence) were flagged
   "Mathlib-scale" in the parent. Is the decomposition into these two TODO lemmas the right
   cut, or is a different reduction (e.g. proving the iso directly on global sections via the
   already-proved tilde dictionaries, bypassing the abstract mate) cheaper?
3. **QUOT definitions before proofs.** The four QUOT stubs are definitions whose *signatures*
   the parent will consume. Is authoring them (esp. `QuotFunctor`, `Grassmannian` as
   `(Over S)ᵒᵖ ⥤ Type u`) the right encoding, and is `Grassmannian.representable`'s
   `∃ Y, Nonempty (RepresentableBy Y)` packaging strong enough to be useful downstream?
4. **Sequencing.** Is bottom-up (FBC/GF leaves first, QUOT defs in parallel) the right order,
   given QUOT representability is the deepest single target?

Render your verdict (SOUND / CHALLENGE / REJECT) per the canonical skeleton and name concrete
correctives. Report under `task_results/`.
