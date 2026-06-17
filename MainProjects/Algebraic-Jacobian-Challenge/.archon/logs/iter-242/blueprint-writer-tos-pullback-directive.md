# Blueprint-writer directive — slug `tos-pullback`

## Chapter
`blueprint/src/chapters/Picard_TensorObjSubstrate.tex` — ONLY this chapter.

## Strategy context (the slice that matters)
The relative-Picard consumer re-bases its line-bundle carrier onto the tensor-invertibility
predicate `IsInvertible M := ∃ N, M ⊗ N ≅ 𝒪`. The substrate lemma is `IsInvertible.pullback`
(pullback preserves ⊗-invertibility for a GENERAL scheme morphism `f : Y → X`). Built in two phases:
**Phase 1 `pullbackUnitIso` (`f^*𝒪_X ≅ 𝒪_Y`) is DONE and axiom-clean (iter-241).** Phase 2
`pullbackTensorIso` (`f^*(M⊗N) ≅ f^*M ⊗ f^*N`) is the active target; the consumer
`lem:isinvertible_pullback` is the composite `pullbackTensorIso⁻¹ ≫ f^*e ≫ pullbackUnitIso`.

A read-only Mathlib analogist consult (`analogies/pullback-tensor.md`) corrected the route. Two edits.

## EDIT A — fix the proof of `lem:pullback_unit_iso` (it is now factually wrong)

The proof block currently describes an affine chart-chase premised on the claim that
"`(Opens.map f.base).Final` need not hold globally for a general morphism". **That claim is FALSE.**
The landed Lean proof is a one-liner. Rewrite the proof block to:

- `Opens.map f.base` (the preimage functor on opens) preserves finite limits — it is a frame
  homomorphism — hence is representably flat, so `final_of_representablyFlat` gives
  `(Opens.map f.base).Final` UNCONDITIONALLY, for every morphism `f`.
- Therefore the Mathlib instance `SheafOfModules.instIsIsoPullbackObjUnitToUnitOfFinal` fires directly:
  `SheafOfModules.pullbackObjUnitToUnit f` is an isomorphism for every `f`, with NO chart-chase.
- `pullbackUnitIso f` is then the bundled iso of that comparison.

DELETE the sentence asserting `Final` "need not hold globally" / "for a general morphism the comparison
functor need not be Final globally" (it is the false premise that caused the obsolete chart-chase).

In the proof block's `\uses{...}`: **remove `lem:pullbackObjUnitToUnit_comp` and
`lem:unitToPushforwardObjUnit_comp`** — the one-line proof does not consume them. Keep
`def:scheme_modules_tensorobj` if still relevant. (Both removed lemmas remain CORRECT standalone blocks
elsewhere in the chapter — do NOT delete those blocks; they are retained. You are only correcting which
lemmas this particular proof cites.) Do not touch any marker.

## EDIT B — rewrite the §6 narrative + the proof of `lem:pullback_tensor_iso` to the new route

The narrative paragraphs immediately under `\label{sec:tensorobj_pullback_monoidality}` (the prose about
"the abstract left-adjoint pullback has NO sectionwise/stalkwise value, so monoidality is established by
local-chart finality"), and the `\begin{proof}` of `lem:pullback_tensor_iso` (its three-part
"(a) build comparison map / (b) finality chart-chase / (c) pointwise is enough" sketch, and the trailing
`CoreMonoidal.ofOplaxMonoidal` discussion) are built on a premise that is now RETRACTED. Rewrite them.

KEEP the lemma STATEMENT of `lem:pullback_tensor_iso` and its `% SOURCE`/`% SOURCE QUOTE` block
(Stacks Modules on Ringed Spaces `lemma-tensor-product-pullback`, `f^*(F⊗G) = f^*F ⊗ f^*G` functorial)
verbatim — that is the correct mathematical source and is unchanged. Only the PROOF and the surrounding
narrative change. The new route (the proof sketch the prover will formalize):

The doctrinal-adjunction tensorator machinery IS present in the pinned Mathlib (it was wrongly believed
absent). But the bundled adjunction API is not directly usable here: the project carries `tensorObj` as a
bespoke sheafified tensor with NO `MonoidalCategory (SheafOfModules)` instance and no
`pushforward.LaxMonoidal`, and the adjunction would yield only an OPLAX comparison map, not the required
isomorphism. So mirror Mathlib's OWN construction in `ModuleCat/Monoidal/Adjunction.lean` (PR #36599),
where the LEFT adjoint's strong-monoidal structure is built explicitly and only then the right adjoint's
lax structure is derived. Three steps:

1. **Concrete strong-monoidal pullback.** Build a concrete functor
   `P = sheafify ∘ (sectionwise extension of scalars)` (the presheaf-level inverse image followed by
   sheafification — the same `sheafificationCompPullback` shape already used in
   `lem:tensorobj_restrict_iso`). Equip `P` with a strong-monoidal structure: the tensorator is the
   linear-algebra strong-monoidal core `TensorProduct.AlgebraTensorModule.distribBaseChange`
   (`(M ⊗_R N) ⊗_R S ≅ (M ⊗_R S) ⊗_S (N ⊗_R S)`, an iso for every ring map, no flatness), sheafified;
   the unit comparison is the already-landed `sheafifyTensorUnitIso` brick. (This is exactly Mathlib's
   `(extendScalars φ).Monoidal` via `distribBaseChange`, lifted to sheaves.)
2. **`P` is left adjoint to `pushforward`.** Exhibit `P ⊣ SheafOfModules.pushforward f` (the concrete
   inverse image is adjoint to pushforward, the universal property of sheafified extension of scalars).
3. **Transport to the abstract pullback.** `Scheme.Modules.pullback f` is defined as
   `(pushforward f).leftAdjoint`. By uniqueness of left adjoints (`Adjunction.leftAdjointUniq`, the same
   device that closed `lem:tensorobj_restrict_iso` in iter-217) there is a natural iso `Scheme.Modules.pullback f ≅ P`.
   The strong-monoidal structure of `P` travels along this iso, giving the comparison
   `f^*(M⊗N) ≅ f^*M ⊗ f^*N` as a genuine ISOMORPHISM, natural in `M, N`. This dissolves the
   "abstract adjoint has no sectionwise formula" obstacle: one never computes the abstract pullback
   sectionwise — one transports a concrete monoidal structure along the adjoint-uniqueness iso.

Record (briefly, as the rationale for not taking shortcuts) the two NEGATIVE results from the analyst:
(i) "an (op)lax monoidal functor preserves invertible objects for free" is FALSE — `Γ` is lax monoidal
but `Γ(ℙ¹, 𝒪(1)) = 0` is not invertible — so one genuinely must prove the comparison is an iso, the
oplax map alone does not suffice; (ii) the "locally-free" route
(`IsLocallyTrivial M → IsInvertible M`) is rejected because it revives the deliberately-shelved
dual/tensor-inverse manufacture (`dual_restrict_iso`/`exists_tensorObj_inverse` arc).

The narrative paragraphs under the section label should be shortened to reflect this: pullback IS
"extension of scalars" and IS strong monoidal; the only subtlety is that the project's pullback is an
ABSTRACT left adjoint, so the strong-monoidal structure is built on a concrete model `P` and transported
via `leftAdjointUniq`. Delete the now-false claims that "no Mathlib tensorator exists" and that
monoidality must be shown by "local-chart finality". Also remove the trailing
`Functor.CoreMonoidal.ofOplaxMonoidal` paragraph (off-path / based on the retracted premise) or replace it
with a one-line note that the full strong-monoidal packaging is delivered by the transported `P.Monoidal`.

Update `lem:pullback_tensor_iso`'s `\uses{}` to reflect the genuine dependencies (e.g.
`def:scheme_modules_tensorobj`, and `lem:tensorobj_restrict_iso` for the `sheafificationCompPullback` /
`leftAdjointUniq` machinery if you cite it). Do not add `lem:pullbackObjUnitToUnit_comp` here unless the
new proof genuinely uses it.

## Citations
- The lemma statement source (Stacks Modules on Ringed Spaces `lemma-tensor-product-pullback`) is ALREADY
  quoted in the block — keep it. If you cite the strong-monoidal extension-of-scalars / base-change-tensor
  fact and want a textbook anchor for the prose, you may reference Stacks "Modules, tensor product and
  pullback" (the same tag already present). Do NOT invent a Mathlib PR as a `% SOURCE` (PR #36599 is a Lean
  implementation pointer, fine to mention in prose as the pattern being mirrored, but it is not a verbatim
  mathematical source — do not write a `% SOURCE QUOTE` for it).
- If you find you need a fresh source quote not already in `references/`, a child reference-retriever is
  authorized via your `references/**` write-domain.

## Out of scope
- Do NOT touch the group-law section (`sec:tensorobj_pic_carrier`, `picCommGroup`, the deferred dual-bridge
  blocks `exists_tensorObj_inverse` / `addCommGroup_via_tensorObj`).
- Do NOT add/remove `\leanok` or `\mathlibok` (sync/review own those).
- Do NOT delete the standalone `lem:pullbackObjUnitToUnit_comp` / `lem:unitToPushforwardObjUnit_comp` blocks.
