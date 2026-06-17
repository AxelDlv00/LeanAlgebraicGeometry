# Effort Breaker Report

## Slug
d3-sq34

## Target
`lem:pullback_tensor_map_basechange`
(`AlgebraicGeometry.Scheme.Modules.pullbackTensorMap_restrict`, D3′)

## Status
COMPLETE — the post-`erw [hδ]` residual is re-expressed as a 3-brick chain
(L_cancel, L_Sq3, L_Sq4) plus a mechanical `comp_δ` split folded into the target's
final-assembly step (L_assemble). The already-closed parts (Sq1/Sq2/Sq2b, the committed
`erw [hδ]`) were left untouched.

## Effort before → after
- target `effort_local`: 19411 → (re-elaborated by `archon dag` next loop pass).
  The hard residual is no longer one monolithic 4-square interleave: three of its four
  open pieces are now standalone named bricks the prover attacks independently; the
  target proof keeps only the interleave/assembly that consumes them.
- sub-lemmas added: 3 (each `\begin{lemma}`+`\begin{proof}`, inserted immediately before
  the target block).

## Chain added (target ← {L_cancel, L_Sq3, L_Sq4})
All three inserted in `chapters/Picard_TensorObjSubstrate.tex` just before the target's
`% NOTE:`/`\begin{lemma}` (≈L3014).

- `\label{lem:sheafify_pullbackcomp_hom_inv_cancel}`
  `\lean{AlgebraicGeometry.Scheme.Modules.sheafifyMap_pullbackComp_hom_inv_id}`
  — (i) the hom/inv cancellation. For every presheaf `T`,
  `a_Z.map (PrPbComp.hom.app T) ≫ a_Z.map (PrPbComp.inv.app T) = id`, where
  `PrPbComp = PresheafOfModules.pullbackComp φ'_f φ'_h`. Proof = `Iso.hom_inv_id_app`
  under `congrArg a_Z.map` + `Functor.map_comp`/`map_id`, spliced by `erw`. `\uses{}`: none
  (leaf brick; the iso `PresheafOfModules.pullbackComp` is a Mathlib decl with no project
  label, named in prose). (effort ≈ tiny — single move.)

- `\label{lem:sheafify_tensor_unit_iso_comp}`
  `\lean{AlgebraicGeometry.Scheme.Modules.sheafifyTensorUnitIso_comp}`
  — (ii) Sq3, the `sheafifyTensorUnitIso` composition coherence. `\uses{def:sheafify_tensor_unit_iso,
  lem:sheafify_tensor_unit_iso_hom_eq_prime, lem:toringcatsheafhom_comp_hom_reconcile}`.
  Proof: `sheafifyTensorUnitIso_hom_eq'` reduces each `.hom` to one `a.map (η⊗η)`, so the
  coherence is η-naturality against `PrPbComp` one tensor factor at a time + bifunctoriality;
  `erw` for the carrier mismatch. (effort ≈ small.)

- `\label{lem:pullback_val_iso_comp}`
  `\lean{AlgebraicGeometry.Scheme.Modules.pullbackValIso_comp}`
  — (iii) Sq4, the `pullbackValIso` composition coherence. `\uses{def:pullback_val_iso,
  lem:sheafificationcomppullback_comp}`. Proof: `pullbackValIso = sheafCompPb⁻¹ ≫ (pullback)(counit)`,
  so the `sheafCompPb⁻¹`-parts reassemble by Sq1 (`sheafificationCompPullback_comp`, CLOSED)
  and the counit-parts by counit pseudofunctoriality across `pullbackComp h f`; a short
  corollary of Sq1. `erw` throughout. (effort ≈ small–medium.)

- Target `lem:pullback_tensor_map_basechange` proof rewritten:
  - statement `\uses` (L3026) and proof `\uses` (L3064) extended with the three new labels.
  - the **Sq3** paragraph now cites `lem:sheafify_tensor_unit_iso_comp`;
  - the **Sq4** paragraphs collapsed to cite `lem:pullback_val_iso_comp`;
  - the stale "Sq1 is the open target" summary replaced with an explicit (i)/(ii)/(iii)
    residual-chain enumeration naming the cancel brick and the `comp_δ` split;
  - the final "four squares do not paste row-by-row" paragraph turned into the named
    **final assembly (L_assemble)** step that consumes the bricks + the `comp_δ` split,
    with the `erw`-everywhere note (the `Sheaf.val Z` carrier-spelling mismatch).

## (iv) comp_δ split / L_assemble
Per the directive this mechanical `Functor.OplaxMonoidal.comp_δ` split was NOT made a
separate block; it is folded into the target proof's final-assembly step and described
there (step (ii) of the residual enumeration + the assembly paragraph). The hardest open
work — sliding `S1_h` past the f-block by naturality of `sheafificationCompPullback h` —
also lives in that assembly paragraph; it is the genuine remaining "interleave" and may
warrant its own re-break next iter if the prover finds it still large (see below).

## Still hard (re-break candidates)
- The **final assembly / interleave** (L_assemble, inside the target proof) is the one piece
  not extracted to its own lemma. It is now small *given* the three bricks (cancel removes the
  inverse pair, `comp_δ` is mechanical, Sq1-naturality does the slide). If the prover reports
  the slide is still heavy, re-dispatch the breaker to extract a fourth brick
  `sheafificationCompPullback_h_naturality_slide` (the `S1_h`-past-f-block naturality square)
  at fine granularity.

## Could not decompose (strategy items)
- None. Every gap the original residual crossed is covered: (i)=L_cancel, (ii)=comp_δ split,
  (iii)=L_Sq3+L_Sq4, assembly=L_assemble.

## References consulted
- `analogies/d3cocycle006.md` — the mate-calculus / `comp_δ` recipe context (no verbatim
  source quote taken; internal categorical construction, no external reference, so no
  `% SOURCE` block is required, consistent with `pullbackComp_δ` and
  `sheafificationCompPullback_comp`).

## Notes for dispatcher
- `\lean{}` names I assigned by convention (prover to create — confirm/scaffold):
  - `AlgebraicGeometry.Scheme.Modules.sheafifyMap_pullbackComp_hom_inv_id`  (L_cancel)
  - `AlgebraicGeometry.Scheme.Modules.sheafifyTensorUnitIso_comp`            (L_Sq3)
  - `AlgebraicGeometry.Scheme.Modules.pullbackValIso_comp`                   (L_Sq4)
  All three are collision-free (grepped Lean + blueprint).
- All cross-elaboration splices in this region require `erw`, not `rw` (the surrounding
  composite is spelled at the `Sheaf.val Z` carrier of the presheaf category — instance-level
  mismatch). This is stated in each brick's proof and in the target's assembly paragraph.
- No new macros needed.
- Verification: `archon blueprint-doctor` is **clean** (no broken `\uses`/`\ref`, no orphan).
  The pre-existing `\begin{lemma}`/`\end{lemma}` off-by-one (81/80 at HEAD) is NOT from this
  edit (I added a balanced 3+3) and doctor does not flag it. Effort numbers update on the
  loop's next `archon dag` elaboration (not run here — heavy LLM step).
- `def:pullback_val_iso` is a `\leanok` definition whose `\lean{pullbackValIso}` is built;
  `lem:sheafificationcomppullback_comp` (Sq1) and `lem:pullbackcomp_delta` (Sq2b) are CLOSED,
  so L_Sq4 and the assembly rest on already-green foundations.
