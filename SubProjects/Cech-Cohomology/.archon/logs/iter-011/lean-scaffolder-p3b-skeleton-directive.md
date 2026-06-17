# Lean Scaffolder Directive — p3b-skeleton (presheaf-Čech bridge file)

## Goal
Create a new file `AlgebraicJacobian/Cohomology/PresheafCech.lean` as the home of the P3b
presheaf-level Čech machinery, so a `mathlib-build` prover can build the chain into it next.
This iter you create ONLY a compiling skeleton + a rich planner-strategy roadmap comment. Do
NOT build the declarations and do NOT leave any `sorry` — the file should compile with imports,
namespace, and the roadmap comment only (a `mathlib-build` prover adds the real declarations
afterward, and that mode forbids `sorry`).

## Read first
- `.archon/analogies/p3b-presheafcech.md` — the authoritative Mathlib-aligned design.
- `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` §"Presheaf-level Čech machinery"
  (`def:cech_free_presheaf_complex`, `def:section_cech_complex`,
  `lem:cech_complex_hom_identification`, `lem:cech_free_complex_quasi_iso`,
  `lem:injective_cech_acyclic`).

## Task — create `AlgebraicJacobian/Cohomology/PresheafCech.lean`
- Copyright header matching the sibling files; `import Mathlib`; if useful,
  `import AlgebraicJacobian.Cohomology.CechHigherDirectImage` (for shared cover/nerve defs — only
  if the prover will need them; otherwise omit to keep it light). `universe u`,
  `open CategoryTheory Limits`, `namespace AlgebraicGeometry`.
- A single rich `/- Planner strategy (P3b presheaf-Čech bridge; see
  analogies/p3b-presheafcech.md + blueprint §Presheaf-level Čech machinery): -/` block comment
  giving the build order and the exact Mathlib hooks, so the mathlib-build prover has the full
  roadmap. Transcribe (in prose, no tactic code) this chain:
  1. `sectionCechComplex` (`\lean{AlgebraicGeometry.sectionCechComplex}`): the section Čech
     complex — a `CochainComplex (ModuleCat (R.obj (op U))) ℕ`, degree `p` = `∏_{i_0…i_p}
     F(U_{i_0…i_p})` via `PresheafOfModules.evaluation`, alternating restriction differential.
     DISTINCT from the relative `CechComplex` (pushforward complex in `S.Modules`).
  2. `cechFreePresheafComplex` (`\lean{AlgebraicGeometry.cechFreePresheafComplex}`): a
     `ChainComplex X.PresheafOfModules ℕ`, degree `p` = `⨁_{i_0…i_p} (PresheafOfModules.free
     _).obj (yoneda.obj U_{i_0…i_p})`, differentials = `(free).map` of the representable
     index-dropping maps `yoneda U_{i_0…i_{p+1}} → yoneda U_{i_0…î_j…}`. NO bespoke `j_!`.
     Category `X.PresheafOfModules = PresheafOfModules X.ringCatSheaf.val`.
  3. `cechComplex_hom_identification` (`\lean{AlgebraicGeometry.cechComplex_hom_identification}`):
     `Hom_{X.PresheafOfModules}(K_•, F) ≅ sectionCechComplex 𝒰 F`, via
     `(PresheafOfModules.freeAdjunction _).homEquiv` + Yoneda + `PresheafOfModules.evaluation`.
  4. `cechFreeComplex_quasiIso` (`\lean{AlgebraicGeometry.cechFreeComplex_quasiIso}`): `K_•`
     resolves `O_𝒰[0]`; homology objectwise; sectionwise contracting homotopy
     `h(s)_{i_0…} = (i_0=i_fix)·s_{i_1…}`.
  5. `injective_cech_acyclic` (`\lean{AlgebraicGeometry.injective_cech_acyclic}`): for injective
     `I : X.Modules`, positive Čech cohomology vanishes — (a) `I`'s image in
     `X.PresheafOfModules` is injective via `CategoryTheory.Injective.injective_of_adjoint`
     applied to `PresheafOfModules.sheafificationAdjunction` (left adjoint sheafification is
     exact ⇒ mono-preserving); (b) `Hom(-,I)` exact carries the free resolution (4) to the
     exact section complex (3), giving `Ȟ^p(𝒰,I)=0` for `p>0`.
  Name the verified Mathlib hooks in the comment: `PresheafOfModules`, `PresheafOfModules.free`,
  `PresheafOfModules.freeAdjunction`, `PresheafOfModules.evaluation`,
  `PresheafOfModules.sheafificationAdjunction`, `CategoryTheory.Injective.injective_of_adjoint`,
  `yoneda`. (These are from the analogist's LSP-verified list.)

## Task — wire the import root
- Add `import AlgebraicJacobian.Cohomology.PresheafCech` to `AlgebraicJacobian.lean`.

## Hard requirement
`lake build` (or `lean_build`) GREEN for the whole project: `PresheafCech.lean` compiles (it
contains only imports + namespace + the comment — no declarations, no `sorry`). If you choose to
add any declaration, it MUST compile and you MUST NOT use `sorry` (use it only as a roadmap host
otherwise). Report the result.

## Constraints
- Do NOT prove anything. Do NOT edit blueprint `.tex`. Do NOT touch the frozen
  `cech_computes_higherDirectImage` or any other file's declarations.

## Report
Confirm green build, the file created, import wiring, and the exact roadmap you injected.
