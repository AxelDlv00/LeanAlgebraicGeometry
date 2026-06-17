# Blueprint-reviewer directive — iter-007 whole-blueprint gate

Audit the WHOLE blueprint (`blueprint/src/chapters/*.tex`). Produce your standard per-chapter checklist
(complete? correct? Lean targets well-formulated? proofs detailed enough to formalize?) plus the
unstarted-phase proposals section.

Project goal (one paragraph): the Line-Bundle Comparison Iso subproject (A.1.c.sub of the
Algebraic-Jacobian-Challenge) formalizes three seed declarations and their dependency cone with zero
inline `sorry`: `lem:pullback_tensor_iso_loctriv` (the loc-triv comparison iso f*(M⊗N)≅f*M⊗f*N, D3′
route), `lem:dual_isLocallyTrivial` (dual of a loc-triv module is loc-triv, DUAL route), and
`thm:rel_pic_addcommgroup_via_tensorobj` (the AddCommGroup on the relative Picard sheaf).

Focus the gate verdict on the consolidated chapter `Picard_TensorObjSubstrate.tex` (it declares
`% archon:covers` over `TensorObjSubstrate.lean`, `StalkTensor.lean`, `Vestigial.lean`,
`DualInverse.lean`, `PresheafInternalHom.lean`) — its single verdict gates whether a prover may run on
`DualInverse.lean` this iter (the active DUAL lane). State explicitly whether that chapter is
complete + correct for the DUAL declarations: `lem:slice_dual_transport`, `lem:slice_dual_transport_inv`,
`lem:dual_restrict_iso`, `lem:dual_isLocallyTrivial`.

Note for context (do not let it bias the audit): a refactor is splitting `DualInverse.lean`'s
`sliceDualTransport` machinery into a new sibling file `DualInverse/SliceTransport.lean` this iter;
fully-qualified Lean names are preserved, so `\lean{}` pins remain valid.
