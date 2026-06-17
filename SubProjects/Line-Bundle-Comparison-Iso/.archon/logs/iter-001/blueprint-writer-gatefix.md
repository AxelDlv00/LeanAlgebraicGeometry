# Blueprint Writer Directive

Target: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

## Strategy context (only the slice that matters)
This chapter consolidates the tensor-object substrate + DUAL dual-inverse machinery.
The DUAL route is now blueprint-complete: the chain
`sliceDualTransport` (`lem:slice_dual_transport`) → `sliceDualTransportInv`
(`lem:slice_dual_transport_inv`) → `dual_restrict_iso` (`lem:dual_restrict_iso`) →
`dual_isLocallyTrivial` (`lem:dual_isLocallyTrivial`) exists with complete
statements and informal proofs. The internal-hom / dual infrastructure
(`sec:tensorobj_dual_infra`, `def:presheaf_internal_hom` … `lem:dual_isLocallyTrivial`)
is realized in `PresheafInternalHom.lean` / `DualInverse.lean`. The blueprint review
flagged ONE stale proof block that blocks the prover-dispatch gate. Fix it.

## PRIMARY action (gate-blocking — must complete)
Rewrite the `\begin{proof} … \end{proof}` block of `lem:tensorobj_inverse_invertible`
(`\lean{...exists_tensorObj_inverse}`, statement ~L1355, proof ~L1412–L1427).
The proof currently opens "\textbf{Infrastructure-blocked.} This statement is
\emph{not} realizable …" — this language is STALE and FALSE now.
- Remove the entire "Infrastructure-blocked / not realizable / cannot even be named"
  framing.
- Replace with a real proof sketch: the internal-hom dual now EXISTS
  (`def:presheaf_internal_hom`, sheafified via `lem:internal_hom_isSheaf`), and
  `lem:dual_isLocallyTrivial` establishes `L^{-1}` is locally trivial. Present the
  three-step route (L⁻¹ is a line bundle via `dual_isLocallyTrivial`; evaluation
  `ε_L : L ⊗ L⁻¹ → 𝒪_X` from `lem:internal_hom_eval`; ε_L is an iso chart-locally,
  upgraded by restriction-detects-iso) as the ACTUAL proof, not a "recorded intended
  route modulo missing object".
- State plainly which Lean obligation currently gates realization: the
  `exists_tensorObj_inverse` body consumes `dual_restrict_iso`, whose Step-4 `isoMk`
  naturality is the open `sorry`. So this lemma's Lean body closes once the DUAL
  chain (`dual_restrict_iso`) lands — phrase as a normal downstream dependency, NOT
  an infrastructure gap.
- Keep the existing `% SOURCE:` / `% SOURCE QUOTE:` (Stacks 01CR) and
  `\textit{Source: …}` lines intact and verbatim. Keep the statement block unchanged.
- Keep the proof's `\uses{...}` accurate (it already lists
  `lem:dual_isLocallyTrivial` etc.).

## SECONDARY action (coverage debt — do only if it does not jeopardise PRIMARY)
Author a blueprint block (statement + `\label` + `\lean{}` + accurate `\uses{}` +
one-line informal proof) for each of these prover-created helpers that currently
have NO blueprint entry. Read each decl's Lean source to derive an accurate `\uses{}`.
Place each near the lemma that consumes it.
1. `Modules.leftAdjointUniq_app_unit_eta_general` → `lem:leftadjointuniq_app_unit_eta_general`
2. `Modules.pullbackObjUnitToUnit_comp` → `lem:pullbackObjUnitToUnit_comp`
3. `Modules.forget_map_pushforward_map` → `lem:forget_map_pushforward_map`
4. `Modules.restrictScalarsId_map` → `lem:restrictscalarsid_map`
5. `Modules.isIso_ε_restrictScalars_appIso_hom` → `lem:isiso_eps_restrictscalars_appiso_hom`
6. `Modules.dualUnitRingSwapHom` → `def:dual_unit_ring_swap_hom`
7. `PresheafOfModules.restrictScalarsLaxε` — if this is a Mathlib declaration, author
   it as a `\mathlibok` Mathlib dependency anchor (state result in project notation,
   `\lean{}` the real Mathlib name); if it is project-local, a normal block.

## Constraints
- Edit ONLY `Picard_TensorObjSubstrate.tex`.
- Do NOT add or remove `\leanok` anywhere (sync-managed). `\mathlibok` allowed ONLY
  on a genuine Mathlib anchor (item 7 if Mathlib).
- Do NOT rename or re-`\lean{}` any existing label.
- No Lean tactic syntax in prose — mathematical sentences only.
