Target: blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

Action: clear the leandag coverage debt for `CechSectionIdentification.lean` (27 isolated
prover-created helpers) and author the ONE missing real lemma block. Two tasks.

## Task 1 — author `lem:sectionCechAugV_π` (a NEW lemma block)
Insert a new `\begin{lemma}…\end{lemma}` + `\begin{proof}…\end{proof}` immediately AFTER the
existing `lem:sectionCechAugV_comp_d` block (around line 8960). It is the degree-0 sibling of
`lem:coreIso_comm_leg`.
- `\label{lem:sectionCechAugV_π}`  `\lean{AlgebraicGeometry.sectionCechAugV_π}`
- Statement (project notation): the `σ`-coordinate (projection `Pi.π … σ`) of the canonical
  augmentation `sectionCechAugV 𝒰 F V` (Def~\ref{def:sectionCechAugV}) equals the plain presheaf
  restriction `Γ(V,F) → Γ(⨅_l (U_{σ l} ∩ V), F)` along the inclusion `⨅_l(U_{σ l}∩V) ⊆ V`
  (`stubInterLeV`). Here `σ : Fin 1 → I`.
- `\uses{def:sectionCechAugV, lem:coreIso_obj_iso, lem:pushPull_sigma_iso,
  lem:pushPull_leg_sections, lem:pushPull_eval_prod_iso}`
- Proof sketch (the p=0 leg unwinding, mirror of `lem:coreIso_comm_leg`'s proof): `sectionCechAugV`
  is the evaluated push–pull augmentation read through `coreIso_objIso 0` (Lemma `lem:coreIso_obj_iso`).
  Project onto the `σ`-leg via `pushPull_sigma_iso` (the proved σ-leg projection seam). The
  augmentation factors through the TERMINAL object of `Over X` — so `a₀(σ) ≫ (augmentation)` collapses
  to the canonical map `Over.mk j_σ ⟶ Over.mk (𝟙 X)` with NO unwinding of `a₀`. The per-leg section
  identification `pushPull_leg_sections` (`Γ(V, pushPullObj F (Over.mk j_σ)) ≅ Γ(U_σ ∩ V, F)`) then
  computes the section as the restriction of `F` along `⨅_l(U_{σ l}∩V) ⊆ V`. No coface combinatorics
  (degree 0). This is the augmentation seam that `lem:cechSection_contractible` invokes for its (I0)/(I1)
  identities.
This is Archon-original (project-bespoke section identification) — NO `% SOURCE` lines needed.

## Task 2 — bundle the 26 proved private helpers into existing `\lean{}` lists
These are isolated internal helpers with no own math content; clear them by APPENDING their FQ Lean
names to the comma-separated `\lean{...}` of the most-related EXISTING block (do NOT create new blocks).
Verify each name exists in `CechSectionIdentification.lean` before adding.

- APPEND to `lem:cechSection_contractible`'s `\lean{...}` (the Stub-6 contracting-homotopy engine):
  `AlgebraicGeometry.cechSectionAugComplex, AlgebraicGeometry.cechSectionCoeff,
  AlgebraicGeometry.cechSectionCoeff_transport, AlgebraicGeometry.cechSectionCoface,
  AlgebraicGeometry.cechSectionD_coord, AlgebraicGeometry.cechSectionDepDiff_zero,
  AlgebraicGeometry.cechSectionHomotopyComp, AlgebraicGeometry.cechSectionHomotopyComp_coord,
  AlgebraicGeometry.cechSectionHomotopyZero, AlgebraicGeometry.cechSectionPrepend,
  AlgebraicGeometry.cechSection_comm_one, AlgebraicGeometry.cechSection_comm_succ,
  AlgebraicGeometry.cechSection_comm_zero, AlgebraicGeometry.cechSection_hsh,
  AlgebraicGeometry.cechSection_hu, AlgebraicGeometry.cechSection_succ_step,
  AlgebraicGeometry.stubConsLe, AlgebraicGeometry.stubConsLeZero, AlgebraicGeometry.stubInterLeV,
  AlgebraicGeometry.stubOpen, AlgebraicGeometry.stubOpen_le_coface,
  AlgebraicGeometry.stubOpen_le_prepend, AlgebraicGeometry.stubRestrTrans,
  AlgebraicGeometry.stubRestrUnique`
- APPEND to `lem:pushPull_sigma_iso`'s `\lean{...}`: `AlgebraicGeometry.pushPull_sigma_iso_π`
  (the σ-leg projection of that iso).
- APPEND to `lem:coreIso_comm_sum`'s `\lean{...}`: `AlgebraicGeometry.abHom_finsetSum_apply`
  (the finite-sum application-distribution helper used in the elementwise sum match).

Constraints: ONLY edit `Cohomology_CechHigherDirectImage.tex`. Do NOT add/remove `\leanok`. Do NOT
touch any other block's prose. Keep `\lean{}` lines as single comma-separated lists (multi-line is fine).
Verify the bundled names against the Lean file before writing.
