# Directive: blueprint-writer snap-assembly

Target: `blueprint/src/chapters/Picard_SectionGradedRing.tex`

Action: Correct the graded-ring assembly design to match the Mathlib idiom established by
the api-alignment consult in `analogies/snap-gcomm.md` (read it first — it carries the
decisive `Mathlib.LinearAlgebra.TensorPower.Basic` precedent, field shapes verified by
`#print`, and concrete signatures). The current `lem:sectionMul_coherent` block (line 1291,
`\lean{...sectionsMul_assoc_unit}`) models `sectionsMul_assoc_unit` as ONE declaration — this
is the wrong shape and is what killed the iter-079 scaffolder.

Rewrite so the chapter states, with `\label`/`\lean`/`\uses` blocks:

1. `def:sectionsCast` — `\lean{AlgebraicGeometry.Scheme.Modules.sectionsCast}`. The index-equality
   transport: Γ (top-open) of `eqToIso (congrArg (tensorPow L) h)`, a `Γ𝒪`-linear equiv
   `sectionDeg L i ≃ₗ sectionDeg L j`. Project analogue of `TensorPower.cast`. One-line informal
   proof. (Add a `sectionsCast_refl` simp-lemma note.)
2. `lem:gradedMonoid_eq_of_cast` — `\lean{AlgebraicGeometry.Scheme.Modules.gradedMonoid_eq_of_cast}`.
   The trivial bridge `(h : a.fst = b.fst) → sectionsCast h a.snd = b.snd → a = b` repackaging a
   cast-mediated component Eq as the `GradedMonoid` sigma `Eq`. Analogue of `TensorPower.Basic`'s
   bridge (`:123`). One-line proof (`cases`/`simp`).
3. Replace the single `lem:sectionMul_coherent` with the FOUR cast-mediated component `Eq`s
   (mirroring `TensorPower.{one_mul,mul_one,mul_assoc}` + `mul_comm`):
   `sectionsMul_one_mul`, `sectionsMul_mul_one`, `sectionsMul_mul_assoc`, `sectionsMul_mul_comm`.
   Keep the existing mathematical proof prose ("reduce to presheaf top-open where eval is STRICT
   monoidal, ride naturality of the sheafification unit η through tensorObjAssoc/tensorObjUnitIso/
   tensorPowAdd"). Keep label `lem:sectionMul_coherent` as the collective umbrella OR introduce
   four sub-labels — your call, but every `\uses{lem:sectionMul_coherent}` elsewhere in the chapter
   (lines 1372, 1412, 1431, 1473) must still resolve (repoint if you split).
4. Update `lem:sectionGradedRing_gcommSemiring` (line 1369) proof sketch to the field-for-field
   `TensorPower.Basic` mirror: `GMul`/`GOne` instances → `GMonoid` (one_mul/mul_one/mul_assoc via
   `gradedMonoid_eq_of_cast`; `gnpow` DEFAULTED — omit) → `GSemiring` (bilinearity FREE from
   `Γ𝒪`-bilinearity of `Γ(μ)∘sectionsMul`; `natCast := n ↦ n • GOne.one`) → `GCommSemiring`
   (mul_comm via the bridge). Keep the existing `\mathlibok` anchor `lem:directSum_gcommSemiring_mathlib`.
5. Update `lem:sectionGradedModule_gmodule` similarly (Gmodule over the GMonoid; `+ᵥ = +` on ℕ;
   `GSMul.smul`; sigma-Eq fields via the same bridge; bilinearity FREE).

Constraints:
- Math-only prose; NO Lean tactic blocks in the informal text.
- Do NOT add `\leanok` (sync owns it). You MAY keep/adjust existing `\mathlibok` anchors.
- Source: `analogies/snap-gcomm.md` (project artefact, no external SOURCE quote needed — bespoke
  infra; cite `Mathlib.LinearAlgebra.TensorPower.Basic` line numbers inline in prose as precedent).
- Out of scope: every other chapter; the crux chain (`tensorObjAssoc`, `tensorPowAdd`,
  `isIso_sheafification_whiskerRight_unit`) is DONE — do not touch those blocks.
- Verify `leandag`: `unknown_uses: 0`, no isolated nodes introduced.
