# Blueprint Reviewer Directive

## Slug
fbc-rereview

## Strategy snapshot

Scoped fast-path re-review of ONE chapter: `blueprint/src/chapters/Cohomology_FlatBaseChange.tex`.
This iter's earlier whole-blueprint review (slug `iter002`) marked this chapter `correct: partial`
with a single must-fix: the proof of `lem:base_change_map_affine_local` (the FBC-A frontier node)
asserted its key naturality step ("pushforwardBaseChangeMap is built from units and counits, all of
which commute with restriction to an open … Granting this compatibility …") instead of deriving it.
A blueprint-writer (slug `fbc-affinelocal`) has since replaced that hand-wave with an explicit
three-step derivation (unfold the (g*,g_*)-adjunction-transpose-of-unit definition → push
restriction through each block via naturality of the transpose + pushforward-commutes-with-
restriction → apply the locality criterion `lem:modules_isIso_iff_affineOpens`).

This is a fast-path gate re-check: confirm whether the chapter now reads `complete: true` AND
`correct: true` with NO must-fix finding, so the FBC prover can be dispatched THIS iter.

### Phases & estimations (FBC rows only — for context)

| Phase | Status | Iters left | LOC | Key Mathlib needs | Risks |
|---|---|---|---|---|---|
| FBC-A — affine lemma, direct-on-sections | ACTIVE | 3–5 | ~150–400 | proved tilde dictionaries; `cancelBaseChange` | section-level mate identification may carry coherence content |
| FBC-B — globalization, H⁰-equalizer | NEXT | 3–6 | ~150–350 | `Module.Flat.{ker,eqLocus}_lTensor_eq`; finite affine cover + sheaf condition | H⁰-as-equalizer infra may need building |

## Routes
Single route: direct-on-sections affine lemma (→ `cancelBaseChange`) + Čech-free H⁰-equalizer
globalization.

## References
- `references/stacks-coherent.tex`: Cohomology of Schemes, "Affine base change" lemma (tag 02KH),
  proof "local on S and S'" step (L920–926) and base-change-diagram (L877–904).

## Focus areas

ONLY `Cohomology_FlatBaseChange.tex`. Concentrate on the repaired proof of
`lem:base_change_map_affine_local`: is the new derivation mathematically sound and detailed enough
for a prover to formalize without guessing whether the restriction-compatibility is definitional/
naturality (it should now be clear it IS) or a non-trivial coherence result? Re-issue the
`complete`/`correct` verdict for this chapter.

You still read the whole blueprint (your descriptor requires it), but the gate decision and your
findings should center on this one chapter; the other three chapters were cleared this iter
(`Picard_FlatteningStratification` and `Picard_QuotScheme` complete+correct;
`Picard_RelativeSpec` complete+correct with a soon-only missing SOURCE QUOTE PROOF) and have not
changed since.

## Known issues (do not re-report as new)
- The three frontier nodes pin to `AlgebraicGeometry.TODO.*` placeholders — intentional scaffold
  targets, `unmatched_lean`, NOT defects.
- `Picard_RelativeSpec.tex` / `thm:relative_spec_univ` missing `% SOURCE QUOTE PROOF:` — known
  soon-severity, deferred to a future writer pass.
