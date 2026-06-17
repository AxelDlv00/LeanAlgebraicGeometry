# Blueprint-writer directive — Picard_RelPicFunctor.tex — align addCommGroup construction to the loc-triv substrate

## Chapter to edit
`blueprint/src/chapters/Picard_RelPicFunctor.tex`, section `sec:relpic_group`
(the group-structure-on-the-relative-Picard-quotient section), block
`\label{lem:rel_pic_sharp_groupoid}` (around lines 74–118) and its proof sketch.

## Strategy context (the slice that matters)
The relative Picard functor carries line bundles on the `IsLocallyTrivial` carrier
`LineBundle.OnProduct πC πT = { M : (pullback πC πT).Modules // IsLocallyTrivial M }`. The remaining
open construction is the `AddCommGroup` instance on the relative-Picard quotient
`Quotient (RelPicPresheaf.preimage_subgroup πC πT) = Pic(C×_S T) / π_T^* Pic(T)`
(Lean: `AlgebraicGeometry.Scheme.PicSharp.addCommGroup`, RelPicFunctor.lean:269, currently `exact sorry`).

**The chapter's current proof sketch is STALE and must be corrected.** It (and the corresponding Lean
comment) frame the gate as the "`Scheme.Modules` monoidal-structure gap" at Mathlib commit `b80f227`
("only `PresheafOfModules.Monoidal.tensorObj` is shipped, one level below"). This is **superseded**: the
project has since BUILT the scheme-level tensor product `AlgebraicGeometry.Scheme.Modules.tensorObj`
(axiom-clean) and the group law `picCommGroup` on tensor-invertible iso-classes (axiom-clean). The real
remaining inputs are now (i) the locally-trivial pullback–tensor comparison iso (being built in parallel
as A.1.c.sub) and (ii) the tensor inverse `exists_tensorObj_inverse`.

## Task — rewrite the proof sketch of `lem:rel_pic_sharp_groupoid` to specify the current construction

Keep the existing `% SOURCE:` / `% SOURCE QUOTE:` Kleiman §2 citation block and the `\textit{Source: …}`
line VERBATIM (do not alter the cited material). Replace only the **proof sketch** (the construction the
prover formalizes) with the following four-step construction in project notation. If clearer, split it
into a short dedicated construction lemma plus a `\begin{proof}`; otherwise put it in the lemma's proof
block.

1. **`AddCommGroup` on the carrier `LineBundle.OnProduct πC πT`.** Addition is the descent of the
   scheme-level tensor product: `[L] + [L'] := [tensorObjOnProduct L L']` (`tensorObjOnProduct`, built
   axiom-clean — preserves local triviality via `tensorObj_isLocallyTrivial`). Zero is `[𝒪]`
   (`SheafOfModules.unit`, locally trivial). Associativity / commutativity / unitality descend from the
   scheme-level isos (`tensorObj_assoc_iso`, `tensorObj_braiding`, `tensorObj_left_unitor`/`_right_unitor`,
   all built axiom-clean) exactly as in the absolute `picCommGroup`. The inverse is
   `-[L] := [Linv]` where `Linv` is supplied by `exists_tensorObj_inverse`, which returns a
   **locally-trivial** witness together with `tensorObj L Linv ≅ 𝒪` — so the inverse stays inside the
   loc-triv carrier (group closure holds; `exists_tensorObj_inverse` is itself a deferred target — the
   easy reverse `IsLocallyTrivial ⟹ IsInvertible` dual-gluing).
2. **The pullback homomorphism `π_T^*`.** `pullbackHom : T.LineBundle →+ LineBundle.OnProduct πC πT`,
   underlying `pullbackAlongProjection` (built). `map_zero` from `π_T^* 𝒪_T ≅ 𝒪_{C×_S T}`
   (`pullbackUnitIso`, axiom-clean, unconditional). `map_add` from the locally-trivial pullback–tensor
   comparison iso `π_T^*(N ⊗ N') ≅ π_T^* N ⊗ π_T^* N'` — i.e. the A.1.c.sub deliverable
   `pullbackTensorIsoOfLocallyTrivial` (`\cref{lem:pullback_tensor_iso_loctriv}`) specialised to the
   projection `π_T` on the `OnProduct` carrier. Model field-for-field on Mathlib
   `CommRing.Pic.mapAlgebra` / `CommRing.Pic.functor` (the `AddMonoidHom` from a ring map respecting
   tensor). Let `H_T := pullbackHom.range`, a subgroup of `LineBundle.OnProduct πC πT`.
3. **Setoid reconciliation (a named sub-step — do not gloss over it).** The setoid
   `RelPicPresheaf.preimage_subgroup πC πT` (iso-class equivalence) coincides with
   `QuotientAddGroup.leftRel H_T`: both encode `L ~ L' ↔ [Linv ⊗ L'] ∈ H_T`. Establishing this
   equivalence of relations is a concrete iso-class argument over the carrier (it needs the tensor
   inverse and the group law, not the comparison iso's computational content).
4. **Transport.** The quotient `Quotient (preimage_subgroup πC πT)` is `Equiv`-equivalent to
   `LineBundle.OnProduct πC πT ⧸ H_T`, which carries the canonical `AddCommGroup` from
   `QuotientAddGroup.Quotient.addCommGroup`; transport along the `Equiv` of step 3 via
   `Equiv.addCommGroup` (Mathlib `Algebra.Group.TransferInstance`) gives the instance on the quotient.

Add to the lemma's `\uses{}`: `lem:pullback_tensor_iso_loctriv` (the comparison iso consumed by
`map_add`), and the existing `def:pullback_along_projection`, `thm:relative_pic_quotient_well_defined`,
`lem:tensorobj_inverse_invertible`, `lem:tensorobj_unit_iso`, `lem:tensorobj_assoc_iso` references as
appropriate.

State explicitly in the prose that the construction is authored in PARALLEL against the comparison-iso
input: the `map_add` step consumes `\cref{lem:pullback_tensor_iso_loctriv}` as an input being built
concurrently (A.1.c.sub), and the inverse step consumes `exists_tensorObj_inverse`
(`\cref{lem:tensorobj_inverse_invertible}`), itself a deferred target.

## Out of scope
- Do NOT alter the cited Kleiman §2 SOURCE QUOTE block or the `\textit{Source:…}` line.
- Do NOT add or remove any `\leanok` / `\mathlibok` markers.
- Do NOT touch the `lem:rel_pic_sharp_functorial` block beyond, if needed, a one-line `\uses` addition;
  the functoriality upgrade is a separate downstream step.
- Do NOT introduce the abandoned general strong-monoidal pullback route anywhere.

If you need to re-quote Kleiman §2 or Stacks 01CR to support a statement, you are authorized to consult
`references/` (the retriever is in your write-domain).
