# Blueprint Reviewer Directive

## Slug
iter023

## Strategy snapshot

Goal: close the Čech-independent leg of the parent Picard cone — FBC (`lem:affine_base_change_pushforward`
+ `thm:flat_base_change_pushforward`), GF (`thm:generic_flatness` + done core `thm:generic_flatness_algebraic`),
QUOT (`def:hilbert_polynomial`, `def:quot_functor`, `def:grassmannian_scheme`, `thm:grassmannian_representable`).
End-state: zero project `sorry` in the 29-node closure, zero project axioms.

`## Phases & estimations`:

| Phase | Status | Iters left | LOC | Key Mathlib needs | Risks |
|---|---|---|---|---|---|
| FBC-A — affine lemma, direct-on-sections | ACTIVE | 1–2 | ~80–200 | proved tilde dictionaries; `conjugateEquiv_counit_symm`, `Adjunction.comp_counit_app` | gstar crux now a 5-lemma chain; hard piece = `inner_eCancel` telescoping |
| FBC-B — globalization, H⁰-equalizer | NEXT | 2–5 | ~120–300 | `Mathlib.RingTheory.Flat.Equalizer`; finite affine cover + sheaf condition | flat-equalizer half Mathlib-backed; H⁰-as-equalizer packaging |
| GF-geo — `genericFlatness` | ACTIVE | 1–2 | ~40–120 | algebraic core (done) + affine-open/finite-cover; `Module.flat_of_isLocalized_maximal` | Γ(F,W)-as-finite-module plumbing may expand |
| QUOT-defs — Quot/Grassmannian defs + predicates | ACTIVE | 4–7 | ~220–560 | `Functor.IsRepresentable`; `Scheme.Modules.pullback`; QCoh→tilde sub-build | P2 rank-`r` local-freeness next |
| SNAP-S1/S3 — section-module input + `Φ_s` extraction | NEXT | 3–6 | ~150–400 | `SheafOfModules` tensor powers of `L_s`; `existsUnique_hilbertPoly` | GATED on Serre `m≫0` agreement / f.g. input — see below |
| QUOT-repr — `thm:grassmannian_representable` | BLOCKED | 6–12 | ~400–1000+ | Grassmannian-of-quotients as a scheme; RelativeSpec → `RepresentableBy` | deepest target |

GF-alg (algebraic core) is now COMPLETE (`genericFlatnessAlgebraic` axiom-clean) — moved to `## Completed`.

## Routes
Single route per target. **This iter's two live prover lanes** are FBC-A (file
`AlgebraicJacobian/Cohomology/FlatBaseChange.lean`, chapter `Cohomology_FlatBaseChange.tex`) and GF-geo
(file `AlgebraicJacobian/Picard/FlatteningStratification.lean`, chapter `Picard_FlatteningStratification.tex`).
Your verdicts on those two chapters are the HARD GATE for this iter's dispatch.

## References
- `references/stacks-coherent.md` → `stacks-coherent.tex`: Stacks 02KH affine base change — backs the FBC chapter.
- `references/nitsure-hilbert-quot.md` → `-src/*.tex`: Nitsure §4 generic flatness — backs the GF chapter (geometric form `thm:generic_flatness`, §4 "generic flatness" theorem).
- `references/hilbert-serre.md`, `stacks-schemes.md`, `stacks-constructions.md`, `hartshorne-algebraic-geometry.md`: QUOT-side.

## Focus areas
1. **`Cohomology_FlatBaseChange.tex` — the newly-expanded gstar chain.** An effort-breaker + blueprint-clean
   round just split `lem:base_change_mate_gstar_transpose` into a 5-lemma `\uses`-linked chain:
   `lem:base_change_mate_inner_unitReduce`, `lem:base_change_mate_inner_eCancel`,
   `lem:base_change_mate_inner_value_eq` (Seam A), `lem:base_change_mate_gstar_generator_close` (Seam B),
   `lem:base_change_mate_gstar_counit_transport` (Seam C), with the target proof rewritten to a 4-move
   combine. Audit: are these five blocks complete + correct, each with adequate proof detail for a prover
   to formalize the named single move? Is the `\uses{}` of each accurate (atoms cited:
   `_legs_unitExpand`, `_legs_gammaDistribute`, the three `gammaMap_pushforwardComp*` collapse atoms,
   `pullbackPushforward_unit_comp`, `pullback_fst_snd_specMap_tensor`, `base_change_mate_unit_value`,
   `base_change_mate_codomain_read`, `base_change_mate_regroupEquiv`, `pullback_isEquivalence_of_iso`)?
   Citation discipline on the two Stacks-derived blocks (`inner_value_eq`, `gstar_generator_close`).
   The previously-flagged "step 2 under-specified" must-fix: confirm whether this expansion resolves it.
2. **`Picard_FlatteningStratification.tex` — `thm:generic_flatness` (geometric form).** The algebraic core
   `thm:generic_flatness_algebraic` is now closed (Lean axiom-clean) — report whether the chapter prose
   still describes it as a `sorry` anywhere. Audit the geometric theorem's 4-step proof sketch (finite
   affine cover → finite module per patch → algebraic form + common basic open → freeness ⟹ flatness):
   complete + correct + detailed enough to formalize? Is the `\lean{}` signature (carries
   `[F.IsQuasicoherent] [F.IsFiniteType]`) faithful to the prose? Citation (Nitsure §4).

## Known issues (do not re-report)
- Pre-existing dangling `\uses{lem:base_change_regroup_linearEquiv}` in `lem:base_change_mate_regroupEquiv`
  (Lean uses an inline `cancelBaseChange`/`comm` route) — the review agent owns a `% NOTE:` for this.
- Three Γ-collapse atoms (`gammaMap_pushforwardComp_hom_eq_id`, `_inv_eq_id`, `gammaMap_pushforwardCongr_hom`)
  are `private` in Lean but `\lean{}`-pinned by full name — known minor.
- The dead `lem:base_change_mate_fstar_reindex` / `_legs` blocks carry a documented `sorry` (superseded
  apparatus, physical removal queued for a later refactor) — known, not a finding.
