# Blueprint Reviewer Directive

## Slug
iter002

## Strategy snapshot

**Goal.** Close the seven `sorry`-bearing nodes of the Čech-independent leg of the parent's
`thm:fga_pic_representability` cone (Kleiman FGA / Nitsure FGA §4–§5), then merge back. Three
independent sub-legs:
- **FBC** — `lem:affine_base_change_pushforward` + `thm:flat_base_change_pushforward` (the i=0
  base-change map `g^* f_* F ⟶ f'_* g'^* F` is an isomorphism).
- **GF** — `thm:generic_flatness` (geometric) with algebraic core `thm:generic_flatness_algebraic`.
- **QUOT** — `def:hilbert_polynomial`, `def:quot_functor`, `def:grassmannian_scheme`,
  `thm:grassmannian_representable`.

End-state: zero project `sorry` in the closure, zero project axioms, kernel-only axioms.

### Phases & estimations (from STRATEGY.md)

| Phase | Status | Iters left | LOC | Key Mathlib needs | Risks |
|---|---|---|---|---|---|
| FBC-A — affine lemma, direct-on-sections | ACTIVE | 3–5 | ~150–400 | proved tilde dictionaries; `cancelBaseChange` | section-level identification of `pushforwardBaseChangeMap` with canonical tensor iso may carry coherence content |
| FBC-B — globalization, H⁰-equalizer | NEXT | 3–6 | ~150–350 | `Module.Flat.{ker,eqLocus}_lTensor_eq`; finite affine cover + sheaf condition | H⁰-as-equalizer infra for `SheafOfModules` may need building |
| GF-alg — algebraic core | ACTIVE | 2–4 | ~80–300 | `exists_free_localizedModule_powers`, `Module.freeLocus`, Noether normalisation | Mathlib-first survey may collapse §4 induction to a thin wrapper |
| GF-geo — `genericFlatness` | NEXT | 1–2 | ~40–120 | algebraic core + affine-open reduction | needs `genericFlatness` re-signed with coherence hyps (currently false as stated) |
| QUOT-defs — Hilbert poly, Quot functor, Grassmannian | ACTIVE | 5–9 | ~250–700 | `Functor.IsRepresentable`, `Scheme.Modules.pullback`, `Polynomial`, `IsProper`; Snapper χ | re-sign needs two project-side predicates absent at the pin; Snapper polynomiality deep |
| QUOT-repr — `thm:grassmannian_representable` | BLOCKED | 6–12 | ~400–1000+ | Grassmannian-of-quotients as a scheme; `RelativeSpec` strengthened to `RepresentableBy` | deepest single target |

## Routes

Single route per target; the leg is a fan of independent leaves merging back upstream. FBC-A and
GF-alg are the live frontier; QUOT-defs authorable in parallel. FBC route pivoted iter-001 to
direct-on-sections + H⁰-equalizer (Čech-free) — see Cohomology_FlatBaseChange.tex.

## References
- `references/nitsure-hilbert-quot.md` → `-src/*.tex`: §4 generic flatness (backs
  `thm:generic_flatness_algebraic`, src L1711–1772), §2/§5 Quot + Grassmannian.
- `references/stacks-coherent.md` → `.tex`: tag 02KH (flat base change of `R^i f_*`, part (2)
  H⁰-with-base-change) — backs `thm:flat_base_change_pushforward` / `lem:affine_base_change_pushforward`.
- `references/stacks-schemes.md` → `.tex`: tag 01I9 — backs `lem:pullback_spec_tilde_iso`.
- `references/stacks-constructions.md` → `.tex`: relative-spectrum tags — backs Picard_RelativeSpec.tex.

## Focus areas

Iter-001 rewrote three chapters (`Cohomology_FlatBaseChange`, `Picard_FlatteningStratification`,
`Picard_QuotScheme`) to address must-fix findings from the prior review; they have NOT been
re-confirmed since. This iter's HARD-GATE decision rests on your verdict for these three. Pay
extra attention to:
- **Cohomology_FlatBaseChange.tex**: the pivoted FBC route (direct-on-sections affine lemma →
  `cancelBaseChange`; H⁰-as-equalizer globalization). Are the two helper lemmas
  (`lem:base_change_map_affine_local`, `lem:pushforward_base_change_mate_cancelBaseChange`) and the
  two main theorems specified in enough detail for a prover, and is the route mathematically sound?
- **Picard_FlatteningStratification.tex**: is `thm:generic_flatness_algebraic`'s proof sketch
  detailed enough, and is the coherence-hypothesis correction on `thm:generic_flatness` faithful?
- **Picard_QuotScheme.tex**: are the four stubs' intended signatures faithful, and are the two
  project-side predicate sub-builds (schematic-support/proper-support; rank-`r` local-freeness)
  adequately specified?

## Known issues (do not re-report as new)
- The three frontier nodes (`thm:generic_flatness_algebraic`, `lem:base_change_map_affine_local`,
  `lem:pushforward_base_change_mate_cancelBaseChange`) pin to `AlgebraicGeometry.TODO.*`
  placeholders. These are intentional scaffold targets (the Lean decl does not exist yet), NOT
  gate failures — they will read `unmatched_lean`. Flag the *blueprint* adequacy; do not treat the
  TODO pin itself as a defect.
- `genericFlatness`'s current Lean signature lacks coherence hyps (`[F.IsQuasicoherent]`
  `[F.IsFiniteType]`) and is false as stated; the chapter already documents the corrected intended
  signature. This is a known re-sign task, not a new finding.
