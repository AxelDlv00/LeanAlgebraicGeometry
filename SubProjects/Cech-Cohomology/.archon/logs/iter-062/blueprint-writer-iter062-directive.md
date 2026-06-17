# Blueprint-writer directive — iter-062

Chapter to edit: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (the consolidated
chapter covering both `CechSectionIdentification.lean` and `OpenImmersionPushforward.lean`).

This iter you make FOUR coordinated edits. They came from the iter-061 lean-vs-blueprint checks (two
MAJOR adequacy gaps) plus a CHURNING progress-critic verdict on the OpenImm route whose corrective is
"retarget + effort-break before re-dispatch." Do NOT touch any `\leanok` marker (the deterministic
sync owns it). You MAY add `% NOTE:` comments.

────────────────────────────────────────────────────────────────────────
## EDIT 1 — CSI: document the two Lean-level blockers in `lem:pushPull_binary_coprod_prod`
────────────────────────────────────────────────────────────────────────

`lem:pushPull_binary_coprod_prod` (statement ~line 8029, proof ~line 8049). The mathematical sketch is
correct, but the prover was blocked at this node in iter-061 by two Lean-specific formalization
obstacles that the sketch omits. Add a `% NOTE:` comment INSIDE the `\begin{proof}...\end{proof}`
(LaTeX comment, does not render) recording the exact fix the prover handed off:

  (a) INSTANCE TRAP. The naive functor `toPresheaf (A ⨿ B) ⋙ (evaluation _ Ab).obj V` gets NO composite
      `PreservesLimitsOfShape` instance — `toPresheaf`'s codomain `TopCat.Presheaf Ab` is a `def`
      wrapper, so `comp_preservesLimitsOfShape` cannot unify the middle category. FIX: use the single
      functor `SheafOfModules.evaluation V` (lands in `ModuleCat`, has a direct
      `PreservesLimitsOfShape` instance), and reduce the iso-check via
      `Scheme.Modules.Hom.isIso_iff_isIso_app` (ModuleCat-valued `.app`) — NOT
      `NatIso.isIso_of_isIso_app` on `toPresheaf`.
  (b) Ab→ModuleCat BRIDGE. `TopCat.Sheaf.isProductOfDisjoint` produces the disjoint-union limit in `Ab`.
      To feed it to `isIso_prodLift_of_isLimit` in `ModuleCat`, reflect the Ab-limit through
      `forget₂ (ModuleCat R) Ab` via `isLimitOfReflects`. The `⊥`/sup open identities are exactly the
      `h₂`/`h₁` fields of `Scheme.coprodPresheafObjIso`; the cone legs `M.presheaf.map (homOfLE _).op`
      match the adjunction-unit components via `restrictAdjunction_unit_app_app` (rfl). ~60–100 LOC of
      cone bookkeeping.

Also: the iter-061 prover added two axiom-clean private helpers that feed this node and currently have
NO blueprint entry (coverage debt — they show as isolated `unmatched` nodes):
  - `AlgebraicGeometry.isIso_prodLift_of_isLimit` — "if `BinaryFan.mk α β` is a limit then `prod.lift α β`
    is an iso" (general categorical fact, via `prodIsProd` + `IsLimit.conePointUniqueUpToIso_hom_comp`).
  - `AlgebraicGeometry.coprodDecompMap` — the binary disjoint-cover comparison map
    `M ⟶ inl_*(M|inl) ⨯ inr_*(M|inr)` (`prod.lift` of two `restrictAdjunction` unit components).
Bundle BOTH names into the `\lean{...}` list of `lem:pushPull_binary_coprod_prod` (append them to the
existing `\lean{AlgebraicGeometry.pushPull_binary_coprod_prod}` line) so the dependency edges are
carried and `unmatched` clears. Do not create separate lemma blocks for them.

────────────────────────────────────────────────────────────────────────
## EDIT 2 — OpenImm: add a node for the already-built reduction `pushforward_iso_qcoh_of_slice_qcoh`
────────────────────────────────────────────────────────────────────────

The iter-061 prover built (axiom-clean) a NON-private lemma with no blueprint entry:
  `AlgebraicGeometry.pushforward_iso_qcoh_of_slice_qcoh` — quasi-coherence of an iso-pushforward
  `Φ.functor.obj H` reduces to quasi-coherence of the restricted pushforwards
  `(Φ H).over (φ.inv ⁻¹ᵁ q.X i)` over the preimage-transported cover. Proof = Mathlib's
  `SheafOfModules.IsQuasicoherent.of_coversTop` + the private cover-transport helper
  `AlgebraicGeometry.coversTop_preimage_of_iso` (which transports `CoversTop` along the scheme iso via
  `Sieve.ofObjects` / `Opens.grothendieckTopology` membership).

Add a new lemma block `lem:pushforward_iso_qcoh_of_slice_qcoh` immediately BEFORE
`lem:pushforward_iso_preserves_qcoh`, with `\lean{AlgebraicGeometry.pushforward_iso_qcoh_of_slice_qcoh,
AlgebraicGeometry.coversTop_preimage_of_iso}` (bundling the private helper to clear its `unmatched`),
`\uses{lem:isQuasicoherent_of_coversTop_mathlib, lem:nonempty_quasicoherentData_mathlib}`, statement +
one-line informal proof as above. Then make `lem:pushforward_iso_preserves_qcoh` `\uses` it.

────────────────────────────────────────────────────────────────────────
## EDIT 3 — OpenImm: RETARGET `lem:pushforward_iso_preserves_qcoh` to the simpler `pullback ψ_r` route,
            and EFFORT-BREAK the `ψ_r` construction into named sub-lemma nodes
────────────────────────────────────────────────────────────────────────

The current proof of `lem:pushforward_iso_preserves_qcoh` (~line 9759) routes the per-slice
presentation transport through `lem:pushforward_commutes_restriction`, which itself needs the heavy
`pushforwardPushforwardEquivalence` quadruple. The iter-061 prover verified a STRICTLY SIMPLER route
and confirmed (mathlib-analogist + exhaustive grep) the heavy route is unnecessary. Retarget the proof:

  SIMPLER ROUTE (per-slice). Fix `i`; set `W := U_i`, `V := φ.inv ⁻¹ᵁ W`. The colimit-preserving functor
  carrying `H.over W`'s presentation to a presentation of `(Φ H).over V` need NOT be the full equivalence
  — use `SheafOfModules.pullback ψ_r`, a LEFT ADJOINT (hence colimit-preserving, giving the
  `PreservesColimitsOfSize` instance `Presentation.map` needs) built from a SINGLE cross-ring slice
  structure-sheaf ring hom `ψ_r`. This collapses the `eqv/φ_r/ψ_r/H₁/H₂` quadruple to one hom + a unit
  iso + a comparison iso. The genuine remaining obstacle (constructing `ψ_r`) is identical either way,
  but everything around it shrinks.

This `ψ_r` construction is the ~100–150 LOC Mathlib gap that has stalled the route for 3 iters. DO NOT
write it as one monolithic lemma. EFFORT-BREAK it into a `\uses`-linked chain of 2–3 small named
sub-lemma blocks, each with `\label`, a `\lean{...}` placeholder name (the prover will create the Lean
decl — these are build targets, mark each `% NOTE: build target. The Lean declaration does not exist
yet.`), a precise statement, `\uses`, and a one-line informal proof. Use these seams (from the prover's
handoff, OpenImm task result lines 60–74):

  - `lem:slice_structureSheaf_hom` (`\lean{AlgebraicGeometry.sliceStructureSheafHom}` or similar):
    construct the slice structure-sheaf ring hom `ψ_r` over `V` by restricting `φ.hom.toRingCatSheafHom`
    to the over-category, using the Beck–Chevalley identity `Over.post F ⋙ Over.forget =
    Over.forget ⋙ F` (which is `rfl`, `CategoryTheory.Over.post_forget_eq_forget_comp`), modulo the
    `(Over.postEquiv e_op).inverse`'s `Over.map (unitIso.inv)` adjustment (the only thing breaking clean
    defeq). This is the genuine novel construction.
  - `lem:pushforward_slice_pullback_iso` (`\lean{AlgebraicGeometry.pushforwardSlicePullbackIso}`):
    the comparison iso `SheafOfModules.pullback ψ_r |>.obj (H.over W transported) ≅ (Φ H).over V`,
    assembled from the pullback-unit iso `pullbackObjUnitToUnit`
    (`Mathlib/.../Sheaf/PullbackFree.lean`) and the opens-equivalence `rfl` `e_op.functor.obj W =
    φ.inv ⁻¹ᵁ W`. One-line: section-by-section the two agree by the unit-iso + Beck–Chevalley `rfl`.
  - (optional 3rd) `lem:pullback_carries_presentation` if the `Presentation.map`+`ofIsIso` transport
    deserves its own node; otherwise fold it into the `pushforward_iso_preserves_qcoh` proof body.

Verified Mathlib anchors the prover confirmed exist (cite as `\mathlibok` anchors only if you create
explicit anchor blocks; otherwise just name them in prose): `SheafOfModules.pullback` (left adjoint,
`IsLeftAdjoint`), `pullbackObjUnitToUnit`, `CategoryTheory.Over.post_forget_eq_forget_comp` (rfl),
`Scheme.Hom.toRingCatSheafHom`, `Presentation.map`, `Presentation.ofIsIso`,
`TopologicalSpace.Opens.mapMapIso`, `Over.postEquiv`.

Rewrite the `lem:pushforward_iso_preserves_qcoh` proof body to use these sub-lemmas (transport `p_i`
via `pullback ψ_r` `Presentation.map` → comparison iso `Presentation.ofIsIso` → per-slice qcoh →
`pushforward_iso_qcoh_of_slice_qcoh`). Update its `\uses` to reference the new sub-lemmas +
`lem:pushforward_iso_qcoh_of_slice_qcoh` + `lem:presentation_map_mathlib` +
`lem:presentation_ofIsIso_mathlib`, and REMOVE `lem:pushforward_commutes_restriction` and
`lem:pushforwardPushforwardEquivalence_mathlib` from its `\uses` (both statement and proof blocks).

────────────────────────────────────────────────────────────────────────
## EDIT 4 — Demote `lem:pushforward_commutes_restriction`; delete the two dead coyoneda anchors
────────────────────────────────────────────────────────────────────────

(a) `lem:pushforward_commutes_restriction` (~line 9690) is now OFF the critical path (the simpler route
    bypasses it). Add a `% NOTE: superseded — the pushforward_iso_preserves_qcoh route no longer depends
    on this lemma; retained as an alternative/reference only.` near its `\label`. Leave the block itself
    (do not delete) but ensure NOTHING on the live `pushforward_iso_preserves_qcoh` chain `\uses` it
    (you already remove that edge in EDIT 3).

(b) `lem:compCoyonedaIso_mathlib` (~line 9584) and `lem:coyoneda_fullyFaithful_mathlib` (~line 9601) are
    DEAD: the `jShriekOU_transport_along_iso` proof was closed in iter-060 via `CorepresentableBy.
    uniqueUpToIso`, NOT via these coyoneda lemmas. They are now isolated blueprint nodes (no `\uses`
    edges in or out). DELETE both blocks, and remove the now-vestigial `\ref{lem:compCoyonedaIso_mathlib}`
    / `\ref{lem:coyoneda_fullyFaithful_mathlib}` references in the surrounding prose (~lines 9640, 9648,
    9664) — reword those sentences so they read coherently without the refs (the transport is via
    corepresentability uniqueness; if a sentence's whole point was the coyoneda step, drop it).

────────────────────────────────────────────────────────────────────────
## Out of scope
────────────────────────────────────────────────────────────────────────
- Do NOT edit any other chapter.
- Do NOT add/remove `\leanok`.
- Do NOT touch the CSI Stub 5/6 augmented-complex blocks or the Stub-1 backbone blocks.
- Keep all existing `% SOURCE:` / `% SOURCE QUOTE:` citation blocks intact.
- Citation discipline: any NEW statement you transcribe from a source needs a verbatim `% SOURCE QUOTE:`
  read from a local `references/` file; the `ψ_r` construction is Archon-original (project-bespoke
  Mathlib-gap infrastructure) — no external source line needed, it stands on its sketch.
