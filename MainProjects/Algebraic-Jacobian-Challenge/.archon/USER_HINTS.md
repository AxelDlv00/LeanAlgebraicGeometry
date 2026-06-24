<!--
USER_HINTS.md — two sections with different lifecycles.

## Temporary hints
  Consumed by the next plan phase and then cleared. Use for one-shot
  steering: "try route X this iter", "skip Lane F this round".

## Persistent hints
  NEVER auto-cleared. These are standing directives that survive every
  iteration reset. The plan agent treats them as HIGHER PRIORITY than
  any conflicting instruction in its own prompt or in
  .archon/prompts/plan.md. Use for project-wide constraints:
    - "never accept axiom X"
    - "don't touch theorem Y until I say so"
    - "always run mathlib-build mode on Lane I"

Format for both sections (one bullet per hint, timestamped):
  - [YYYY-MM-DDTHH:MM:SSZ] hint text

Hints are written by 'archon discuss' or directly by you. In discuss,
the agent will ask which section to target; in a direct edit, place your
bullet under the appropriate heading.

File-specific hints (one .lean file only) belong as /- USER: ... -/
comments inside that file — NOT here.
-->

## Temporary hints

- [2026-06-24T14:52:00Z] NEXT — prioritise Stacks 02KH flat base change (`cech_flatBaseChange`, `Cohomology/CechHigherDirectImageUnconditional.lean`, SEPARATED case, no spectral sequence needed) via the ČECH route. The homology side is already sorry-free; only TWO leaves remain: (1) `pullback_preservesFiniteLimits [Flat g]` (flat ⇒ `g^*` left-exact — reduces to presheaf-pullback left-exactness; `forget` and `sheafification` already preserve finite limits in Mathlib, see the docstring's verified reduction), and (2) `cechComplex_baseChange_iso` (Stacks 02KG) — build the per-degree affine base-change iso from the sorry-free concrete-tilde primitives reused from FBC-B (`pushforward_spec_tilde_iso`/`pullback_spec_tilde_iso` + `cancelBaseChange`) and assemble into a chain iso; this can bypass `affineBaseChange_pushforward_iso`'s adjoint-mate identification (the part that walled FBC-B), since only *a* natural iso of complexes is required, not the canonical map.

## Persistent hints

- [2026-05-31T00:00:00Z] AUTONOMOUS OPERATION (permanent until user removes this hint): There is no reason for Archon to escalate to the user. It should always find the best path, think about all possibilities, and make the correct decision. In some cases refactoring may be a good option to a dead-end.
- [2026-05-31T00:00:00Z] PARALLELISM VIA FILE SPLITTING: Use more parallelism by dividing files with many theorems or lemmas into smaller, semantically relevant files that can work with parallel provers.
- [2026-06-23T00:00:00Z] ROUTE C PAUSE — now enforced by DELETION (supersedes the 2026-05-28 hint). The genus-0 lane was removed entirely on 2026-06-23: `genusZeroWitness`/`positiveGenusWitness` collapsed into the single uniform Pic⁰ witness `picardJacobianWitness`, and the files H1Vanishing/RRFormula/OCofP/OcOfD/RationalCurveIso/BareScheme/GmScaling/RigidityKbar/AbelianVarietyRigidity/Rigidity/Differentials/Cotangent/*/Genus0BaseObjects/* were deleted; the genus-0 `RiemannRoch` subproject is renamed `RiemannRoch-[obsolete]`. No genus-0 / Route-C work remains to pause. Standing intent unchanged: all prover capacity on Route A (FGA Pic⁰ representability). KEPT general material: `RigidityLemma.lean` (Milne §I.1) and general `WeilDivisor.lean`. See `memory/genus-split-removed-uniform-pic0.md`.
- [2026-05-29T00:00:00Z] PRIMARY GOAL — Pic_{C/k} representability (A.2.c): The primary near-term proof objective is a complete proof of Pic_{C/k} representability. Prove all dependencies bottom-up first, then close A.2.c itself. Do not dispatch work on A.3 or deeper gated layers before A.2.c is closed.
- [2026-05-28T00:00:00Z] REFERENCE-DRIVEN PROOFS: Every prover lane directive must cite the precise theorem/proposition number from the mathematical references (Kleiman "Picard schemes" FGA, Nitsure FGA chapter, Milne "Abelian Varieties", SGA 7, Stacks Project) corresponding to each declaration being proved. If a proof step cannot be directly traced to a reference, find the reference before dispatching the prover — do not improvise mathematical content without a reference anchor.
- [2026-06-24T14:52:00Z] KLEIMAN 4.8 MASTER SKELETON: The master proof of Pic_{C/k} representability (`thm:fga_pic_representability`, Lean `AlgebraicGeometry.Scheme.PicScheme.representable`) MUST follow the four-step proof already transcribed from Kleiman "The Picard scheme" §4 Thm 4.8 (+ Cor 4.18.3) in `blueprint/src/chapters/Picard_FGAPicRepresentability.tex`: (1) stratify Pic^♯ by Hilbert polynomial P^φ — openness of the strata IS Kleiman's flat-base-change argument (Stacks 02KH / cohomology-and-base-change, cf. EGA III 7.9.11); (2) bound twists by m-regularity; (3) factor through the Abel map Div_{C/k} → Pic^♯ with Div_{C/k} open in Hilb_{C/k} = Quot; (4) descend via the smooth-proper-quotient lemma (Kleiman §4 Lem 4.9). Prove dependencies BOTTOM-UP (Quot/Hilb → Abel map → flat base change → strata openness → quotient descent), each node cited to its Kleiman §/Thm number. Flat base change (02KH) is a genuine PREREQUISITE of Step 1, not optional.
- [2026-06-24T14:52:00Z] BLUEPRINT-FIRST QUALITY: Invest real effort in the blueprint BEFORE dispatching provers. For every node on the Kleiman 4.8 path, ensure its blueprint entry has (a) a complete proof sketch traced step-by-step to the precise Kleiman §/Thm or Stacks tag, (b) a verbatim SOURCE QUOTE of the reference statement, (c) a correct `\lean{}` binding, and (d) full `\uses{}` edges to every dependency. A node whose sketch is vague or whose `\uses{}` graph is incomplete is NOT ready to prove — repair the blueprint first. Treat good blueprints as a first-class deliverable, not a byproduct of the Lean.
- [2026-06-24T14:52:00Z] STACKS 02KH FLAT BASE CHANGE: prove `cech_flatBaseChange` (`Cohomology/CechHigherDirectImageUnconditional.lean`; blueprint `lem:cech_flat_base_change` + the "Homology-side machinery" section of `Cohomology_CechHigherDirectImage.tex`). SCOPE & SPECTRAL SEQUENCE: the current Lean lemma carries `[IsSeparated f]` — the SEPARATED case, which needs NO spectral sequence, and this case already suffices for the curve/Jacobian application (`f` = projective, hence separated, family). The FULL general (quasi-separated) 02KH DOES use the Čech-to-cohomology spectral sequence (Stacks/Cohomology Lemma 20.11.5) to lift the separated case to general — so if/when you extend `cech_flatBaseChange` past the separated case, that SS is required; Mathlib has only the ABSTRACT `SpectralObject`/`SpectralSequence` framework, so the concrete Čech-to-cohomology SS must be built from it (a real sub-development — scope it as its own blueprint node). Status of the separated lemma: assembly + all homology machinery sorry-free; two open leaves — `pullback_preservesFiniteLimits` (flat ⇒ `g^*` left-exact) and `cechComplex_baseChange_iso` (Stacks 02KG, the termwise affine base change). For the termwise ingredient PREFER the sorry-free CONCRETE-tilde isos (`pushforward_spec_tilde_iso`/`pullback_spec_tilde_iso` + `cancelBaseChange`), built directly into a chain iso — this can BYPASS the canonical base-change-map identification (`affineBaseChange_pushforward_iso` via the adjoint mate) that walled FBC-B, since `cechComplex_baseChange_iso` only needs *a* natural iso of complexes, not specifically the canonical map.

