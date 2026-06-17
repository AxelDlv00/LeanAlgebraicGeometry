# Blueprint Reviewer Directive

## Slug
iter011

## Strategy snapshot

**Goal.** Prove `AlgebraicGeometry.cech_computes_higherDirectImage` (`lem:cech_computes_cohomology`),
the protected frozen-signature target: for `f : X ⟶ S` separated + quasi-compact, `F` quasi-coherent,
`𝒰` a finite affine open cover of `X`, an iso in weak-existence form
`Nonempty ((CechComplex f 𝒰 F).homology i ≅ higherDirectImage f i F)` (under
`[HasInjectiveResolutions X.Modules]`), `higherDirectImage f i F = ((pushforward f).rightDerived i).obj F`.
Zero inline sorry in the cone, zero project axioms, kernel-only axioms.

### Phases & estimations (full table — for unstarted-phase detection)

| Phase | Status | Iters left | LOC | Key Mathlib needs | Risks |
|---|---|---|---|---|---|
| P3 standard-cover Čech vanishing (`CechAcyclic.affine`) | ACTIVE (statement-gap fix first) | ~3–5 | ~200–400 | `affineOpenCoverOfSpanRangeEqTop` + `exact_of_isLocalized_span` (Mathlib-native); from-scratch L1 `Γ(D(f_σ))=M_{f_σ}` + L3 `Away(f_r)`-local homotopy. | Narrow non-protected `CechAcyclic.affine` to a standard-cover bundle `(s,hs)`. Supplies only condition (3) of the bridge. |
| P3b Čech↔derived bridge (minimal, torsor-free) → `affine_serre_vanishing` | NEXT (unblocks all geometry) | ~4–7 | ~300–600 | presheaf-Čech for `O_X`-modules: enough injectives; Čech complex exact as functor on presheaves; `injective_cech_acyclic`; `ses_cech_h1`; `cech_vanish_basis` (01EO) dimension-shift. ALL absent from Mathlib. | Irreducible brick: comparing explicit Čech complex to `rightDerived` MUST cross "injectives are Čech-acyclic". Real from-scratch homological algebra over `O_X`-modules. |
| P5a vanishing inputs (consume P3b) | AFTER P3b | ~3–5 | ~250–500 | augmented-Čech-is-resolution; presheaf description `R^if_*=sheafify(V↦H^i(f⁻¹V))` (01XJ); open-immersion/relative affine vanishing | All P5a decls ABSENT from Lean. `higher_direct_image_presheaf` is P3/P3b-independent (parallelisable). |
| P5b comparison assembly | LAST (needs P3, P3b, P4, P5a) | ~2–3 | ~150–300 | P4 engine + P5a resolution + termwise `f_*`-acyclicity | Final Route-A assembly of protected `cech_computes_higherDirectImage`. |

(P1, P2, P4 are COMPLETE — see `## Completed` in STRATEGY.md; no proposals needed for those.)

## Routes

- **Route A — acyclic-resolution comparison (CHOSEN).** Augmented Čech complex is (i) a resolution
  and (ii) termwise `(pushforward f)`-acyclic; P4 abstract lemma gives `Hⁱ(f_*C•)≅Rⁱf_*F`. Acyclicity
  input reduces to affine Serre vanishing via the P3b bridge.
- **Route B — two spectral sequences (REJECTED, fallback only).** Both SS absent from Mathlib; rests
  on the SAME `injective_cech_acyclic` brick as A. Not represented in the blueprint by design.

## References
- `references/stacks-cohomology.md` → `stacks-cohomology.tex`: ch. Cohomology — 01XJ
  (`lemma-describe-higher-direct-images`), 01EO (`lemma-cech-vanish-basis`), `lemma-ses-cech-h1`,
  01EN (`lemma-injective-trivial-cech`). Backs the P3b bridge + P5a `higher_direct_image_presheaf`.
- `references/stacks-coherent.md` → `stacks-coherent.tex`: ch. Cohomology of Schemes — 02KE, 02KG,
  `lemma-cech-cohomology-quasi-coherent-trivial`. Backs P3 + the comparison theorem.
- `references/homological-acyclic.md` → `homological-acyclic-{derived,homology}.tex`: Tags 0157/015C/015E
  (Leray acyclicity). Backs `Cohomology_AcyclicResolution.tex` (P4, DONE).

## Focus areas
- **`Cohomology_CechHigherDirectImage.tex`** is the critical chapter this iter — it was substantially
  restructured iter-010 (circularity repair + the new minimal torsor-free Čech↔derived bridge:
  `lem:injective_cech_acyclic`, `lem:ses_cech_h1`, rewritten `lem:cech_to_cohomology_on_basis`). This
  consolidated chapter (`% archon:covers CechHigherDirectImage.lean`) gates EVERY frontier node. I need
  a fresh HARD GATE verdict on it. Pay special attention to:
  - Is `lem:injective_cech_acyclic` complete + detailed enough to formalize, or does it need
    effort-breaking into sub-lemmas (presheaf-Čech enough-injectives, Čech-complex-exact-as-functor,
    `Hom(K(𝒰)•,I)=Č•(𝒰,I)`, δ-functor universality)? Judge whether its single block is prover-ready.
  - Is the rewritten `lem:cech_to_cohomology_on_basis` now NON-circular (its proof `\uses` must NOT
    route `affine_serre_vanishing` back into the basis lemma)? Confirm the cycle is broken.
  - `lem:cech_to_cohomology_on_basis` statement↔`\lean{cech_eq_cohomology_of_basis}` shape parity
    (statement now concludes vanishing `H^p=0`).
  - `lem:cech_acyclic_affine` (`CechAcyclic.affine`) — the P3 long pole, signature-narrowing to the
    `def:standard_affine_cover` bundle.

## Known issues
- The frontier nodes are ABSENT from Lean (scaffolding planned this iter) — `\lean{}` hints name
  to-be-created decls; that is expected, not a "target doesn't exist" fault. Judge the BLUEPRINT
  completeness/correctness, not Lean presence.
- `def:standard_affine_cover` is a `\mathlibok` anchor to `Scheme.affineOpenCoverOfSpanRangeEqTop`
  (verified present iter-010). Do re-confirm its faithfulness.
- P4 chapter (`Cohomology_AcyclicResolution.tex`) is DONE/closed; stale `.lean`-side comments are
  tracked separately. Audit its blueprint correctness but no prover lane depends on it.
