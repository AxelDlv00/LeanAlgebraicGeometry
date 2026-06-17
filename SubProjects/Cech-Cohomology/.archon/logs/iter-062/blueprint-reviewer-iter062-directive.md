# Blueprint-reviewer directive — iter-062

Perform your standard whole-blueprint audit (all chapters under `blueprint/src/chapters/`). Produce the
per-chapter completeness + correctness checklist and the HARD-GATE verdict per file.

Context for this iter (do not let it narrow your whole-blueprint view — the cross-chapter check is the point):
Two files are about to receive prover work, BOTH backed by the consolidated chapter
`Cohomology_CechHigherDirectImage.tex`:
  - `CechSectionIdentification.lean` — Stub-2 chain: `lem:isIso_modules_of_toPresheaf` (done),
    `lem:pushPull_binary_coprod_prod` (L2, now carries a `% NOTE:` documenting the instance-trap fix +
    Ab→ModuleCat bridge), `lem:pushPull_coprod_prod`, `lem:pushPull_sigma_iso`.
  - `OpenImmersionPushforward.lean` — `hqc`: `lem:pushforward_iso_qcoh_of_slice_qcoh` (new reduction node,
    built), `lem:pushforward_iso_preserves_qcoh` (retargeted this iter to the `pullback ψ_r` route) and its
    two new build-target sub-lemmas (`lem:slice_structureSheaf_hom`, `lem:pushforward_slice_pullback_iso`
    or whatever the writer named them), plus the demoted `lem:pushforward_commutes_restriction`.

Confirm for the HARD GATE: is `Cohomology_CechHigherDirectImage.tex` complete + correct for BOTH files'
active nodes this iter? In particular:
  (1) Does the `lem:pushPull_binary_coprod_prod` `% NOTE:` adequately specify the L2 formalization route
      (instance fix + bridge) so a prover is no longer blind there?
  (2) Is the retargeted `lem:pushforward_iso_preserves_qcoh` route (`pullback ψ_r` + the new sub-lemmas)
      coherent, with resolvable `\uses{}`, no dangling reference to the demoted/deleted lemmas, and the
      `ψ_r` gap genuinely effort-broken into independently-provable sub-lemma nodes (not a re-disguised
      monolith)?
  (3) Are the two new build-target sub-lemmas' statements precise enough to formalize (signatures,
      what they take, what they produce)?
Flag any must-fix-this-iter items on these chapters specifically.
