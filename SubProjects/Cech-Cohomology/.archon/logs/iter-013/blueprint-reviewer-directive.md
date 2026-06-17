# Blueprint Reviewer Directive

## Slug
iter013-postwire

## Strategy snapshot

**Goal**: Prove `AlgebraicGeometry.cech_computes_higherDirectImage` (`lem:cech_computes_cohomology`),
the protected frozen-signature target: for `f : X ⟶ S` separated quasi-compact, `F` quasi-coherent,
`𝒰` a finite affine open cover, `Nonempty ((CechComplex f 𝒰 F).homology i ≅ higherDirectImage f i F)`.
Route A (chosen): the augmented Čech complex is a `(pushforward f)`-acyclic resolution of `F`; the
abstract Leray acyclic-resolution lemma (P4, done) then computes `Rⁱf_* F`. Acyclicity reduces to
affine Serre vanishing, obtained via the torsor-free Čech↔derived bridge P3b.

### Phases & estimations
| Phase | Status | Iters left |
|---|---|---|
| P3 standard-cover Čech vanishing (`CechAcyclic.affine`) | ACTIVE | ~3–5 |
| P3b Čech↔derived bridge → `affine_serre_vanishing` | BLOCKED | ~6–9 |
| P5a vanishing inputs (01XJ `higher_direct_image_presheaf`, open-immersion/affine vanishing) | BLOCKED | ~3–5 |
| P5b comparison assembly (frozen goal) | BLOCKED | ~2–3 |

Completed: P1 push–pull functor laws, P2 CechNerve/CechComplex, P4 acyclic-resolution lemma
(`AcyclicResolution.lean`, Stacks 015E Leray).

## Routes
Single route (Route A). Route B (two spectral sequences) is REJECTED/fallback and intentionally has
NO blueprint coverage — do not flag it as a missing route.

## References
- `references/stacks-cohomology.md` → `stacks-cohomology.tex`: ch. Cohomology — `lemma-injective-trivial-cech`,
  `lemma-cech-vanish-basis` (01EO), `lemma-describe-higher-direct-images` (01XJ). Backs the P3b/P5a blocks
  in `Cohomology_CechHigherDirectImage.tex`.
- `references/stacks-coherent.md` → `stacks-coherent.tex`: ch. Cohomology of Schemes — 02KE, 02KG (affine
  Serre vanishing), Čech computes cohomology. Backs `lem:cech_acyclic_affine`, `affine_serre_vanishing`.
- `references/homological-acyclic.md` → `homological-acyclic-derived.tex`: Stacks 0157/015C/015E (right-acyclic,
  Leray acyclicity lemma). Backs `Cohomology_AcyclicResolution.tex`.

## Focus areas
This iteration the DAG agent made PURELY STRUCTURAL edits (no math-content changes) to fix two leandag
gate gaps. Please confirm they are mathematically faithful:
1. **Connectivity (statement-level `\uses` mirroring).** leandag in this project graphs ONLY statement-level
   `\uses{}`, not proof-block `\uses{}`. The P3b chain kept its real deps only in proof blocks, so 8 nodes
   were severed from the goal cone and the two `\mathlibok` anchors were isolated. Fixed by mirroring proof
   deps into the statement `\uses` of:
   - `lem:injective_cech_acyclic` (added def:section_cech_complex, lem:cech_complex_hom_identification,
     lem:cech_free_complex_quasi_iso, lem:injective_of_adjoint, lem:mod_pmod_adjunction)
   - `lem:cech_to_cohomology_on_basis` (added lem:injective_cech_acyclic, lem:ses_cech_h1, lem:cech_acyclic_affine)
   Confirm these statement-level `\uses` additions match the actual mathematical dependencies of each proof.
2. **1-to-1 coverage (helper bundling).** 28 internal Lean helpers (push-pull `rawPushPullMap*`,
   `coverCechNerveOver(Aug)`; cosyzygy/twistedBiprod/split-resolution helpers in AcyclicResolution) had no
   blueprint entry. Bundled their `\lean{}` names into the most appropriate existing declaration's `\lean{}`
   list (the established pattern — e.g. `lem:horseshoe_chainMap` already bundles ~10 names). Confirm each
   helper was bundled under a mathematically related declaration (not a wrong bundle).

## Known issues
- All "Unproved" blueprint decls (P3/P3b/P5a/P5b) are intentionally not-yet-formalized — prover-loop work,
  not blueprint gaps. Do NOT flag absent `\leanok` as incompleteness.
- `lem:cech_acyclic_affine` and `lem:cech_computes_cohomology` carry an in-progress Lean `sorry` — expected.
- `\lean{}` placeholders pointing at not-yet-scaffolded project decls (P5a) and at Mathlib decls (`\mathlibok`
  anchors) are expected and allowed (tex precedes Lean).
