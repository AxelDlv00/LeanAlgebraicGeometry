# Blueprint review — iter-060 (HARD GATE for the two active prover lanes)

Audit the WHOLE blueprint under `blueprint/src/chapters/`. Two `.lean` files will receive
prover work this iter, both covered by the consolidated chapter
`Cohomology_CechHigherDirectImage.tex`:

- `AlgebraicJacobian/Cohomology/CechSectionIdentification.lean` (Sub-brick A / Stub-1 consumer)
- `AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean` (Need#1 transport: hjt/hqc)

The consolidated chapter was substantially rewritten THIS iter by two writer rounds:
1. `lem:jshriek_transport_along_iso` (hjt) — proof replaced by a 3-step corepresentability
   chain (`compCoyonedaIso` + `sectionsFunctorCorepIso` whiskered + a definitional relabel,
   reflected via `Coyoneda.fullyFaithful`). Three obsolete sub-lemmas deleted
   (`lem:pushforward_commutes_free/_sheafify`, `lem:yoneda_transport_along_homeo`).
2. `lem:pushforward_iso_preserves_qcoh` (hqc) — proof rewritten to an `of_coversTop` /
   `QuasicoherentData` transport, with a NEW R1 sub-lemma `lem:pushforward_commutes_restriction`
   ("pushforward commutes with restriction to an open"). New Mathlib anchors added
   (`isQuasicoherent_of_coversTop`, `nonempty_quasicoherentData`, `coyoneda_fullyFaithful`,
   `isAffineOpen_image_of_iso`).
3. Coverage-debt blocks added for the 4 OpenImm + 2 CSI helpers landed in iter-059.
4. Expanded sketches for `lem:cech_backbone_left_sigma` (universe-reduction / Fin-reindex API)
   and `lem:coproduct_distrib_fibrePower` (slice-product normal form).

Report your standard per-chapter checklist (complete / correct, must-fix items). The HARD GATE
question for this iter: is `Cohomology_CechHigherDirectImage.tex` complete + correct with no
must-fix finding, so that prover lanes on the two files above may proceed? Pay particular
attention to whether the rewritten hjt and hqc proof sketches are detailed enough to formalize
(named Mathlib API at each step) and whether their `\uses{}` sets are accurate.
