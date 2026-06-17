# Lean Audit Report

## Slug
ts239

## Iteration
239

## Scope
- files audited: 2
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Cohomology/FlatBaseChange.lean

- **outdated comments**: 1 flagged
- **suspect definitions**: 3 flagged (sorry-bearing load-bearing declarations)
- **dead-end proofs**: 0
- **bad practices**: 1 flagged (proof duplication)
- **excuse-comments**: 1 flagged
- **notes**:
  - **NEW: `gammaPushforwardIsoAt` (lines 328–349)** — Genuine, non-vacuous construction. The statement is the correct arbitrary-open generalisation of `gammaPushforwardIso`: for a ring map `φ : R ⟶ R'`, any `N : (Spec R').Modules`, and any open `U : (Spec R).Opens`, it asserts an iso between `(modulesSpecToSheaf ∘ pushforward φ N).val.obj U` and `(restrictScalars φ).obj ((modulesSpecToSheaf N).val.obj ((Spec.map φ)⁻¹ U))`. The proof is axiom-clean and contains no sorry. The key mathematical insight (that `modulesSpecToSheaf` uses the global-ring action at `⊤` uniformly for all opens, so the ring-level comparison is always at `⊤` regardless of `U`) is correctly captured. The statement is not degenerate — it genuinely identifies the sections at any open. **Code smell**: the proof body (lines 334–349) is an almost verbatim copy-paste of `gammaPushforwardIso` (lines 289–302), differing only in the definition of `SecN`. `gammaPushforwardIso` could be obtained as the special case `U = ⊤` of `gammaPushforwardIsoAt`; carrying two independent proof copies is a maintenance liability. Minor severity.
  - **NEW: `tildeRestriction_isLocalizedModule` (lines 480–526)** — Genuine, non-vacuous construction. The statement asserts that, for `M : ModuleCat R'` and `b : R'`, the `modulesSpecToSheaf`-restriction map from `⊤` to `D(b)` makes the target a localized module at `Submonoid.powers b`. The proof is axiom-clean. The argument: (i) bijectivity of `tilde.toOpen M ⊤` (established by `IsLocalizedModule.exists_of_eq` and `IsLocalizedModule.surj` for `powers (1 : R')`), constructing an equivalence `le : M ≃ₗ[R'] Γ(M^~, ⊤)`; (ii) the triangle identity `tilde.toOpen_res` gives `toOpen ⊤ ≫ ρ = toOpen D(b)`; (iii) `LinearEquiv.eq_comp_toLinearMap_symm` rewrites `ρ = toOpen(D b) ∘ₗ le⁻¹`; (iv) `IsLocalizedModule.of_linearEquiv_right` closes. No sorry, no trivialising hypothesis. Axiom-clean.
  - **`pushforward_spec_tilde_iso` (lines 535–572)** — The skeleton is **real**: `apply pushforward_spec_tilde_iso_of_isLocalizedModule φ M` followed by `intro a` genuinely reduces to the single goal of discharging `hloc a`. The `sorry` at line 572 is the ONLY gap in this declaration; the conditional form `pushforward_spec_tilde_iso_of_isLocalizedModule` is sorry-free and axiom-clean. The surrounding strategy comments (lines 541–571) accurately describe both the intended proof route and the precise obstacle (carrier-instance wall: the naturality square between `gammaPushforwardIsoAt φ (tilde M) ⊤` and `gammaPushforwardIsoAt φ (tilde M) (D a)` requires an `R`-module structure on `R'`-side sections via `Module.compHom` that is not synthesizable). The `sorry` is the only gap. Load-bearing: blocks `affineBaseChange_pushforward_iso`.
  - **`affineBaseChange_pushforward_iso` (lines 580–604)** — `sorry` body at line 604. Top-level theorem (affine flat base change, Stacks "Affine base change" lemma). The body reduces to `rw [Modules.isIso_iff_isIso_app_affineOpens]` followed by `intro U` and a `sorry`. The reduction is genuine. Load-bearing: blocks `flatBaseChange_pushforward_isIso`.
  - **`flatBaseChange_pushforward_isIso` (lines 613–626)** — `sorry` body at line 626. Top-level theorem (flat base change `i = 0`, Stacks Tag 02KH). The body comment (lines 617–625) reads "Proof strategy (Stacks 02KH, `i = 0`), deferred to a later iteration:" — this is a direct admission that the proof is intentionally incomplete and scheduled for later. **Excuse-comment** on a load-bearing theorem. Severity: critical.
  - **Long STATUS block (lines 181–244) in the `/-!` docstring heading** — accurate but sprawling. Contains multi-iter history (iter-234/iter-236 entries) and references to `task_results` internal project state files (line 205: "See `task_results` for the full attempt log") — these are workflow artifacts that should not appear in source docstrings. The mathematical content (route (a) dead-end, route (b) execution) is accurate and not stale. Mild concern: "See `task_results`" is not a navigable source reference; `task_results` is a runtime artifact directory. Minor severity.
  - **`IsLocalizedModule.powers_restrictScalars` (lines 452–471)** — A legitimate lemma (the "converse" direction of `IsLocalizedModule.of_restrictScalars`). The proof unfolds each `IsLocalizedModule` field and applies the algebraic-map submonoid bridge correctly. No sorry. The docstring claim "Mathlib ships only the forward direction" is taken at face value (unverifiable without running the LSP, but consistent with the project's need to build it).
  - **`pushforward_spec_tilde_iso_of_isLocalizedModule` (lines 428–443)** — Sorry-free. Uses `Modules.isIso_of_isIso_app_of_isBasis` over basic opens and delegates to `fromTildeΓ_app_isIso_of_isLocalizedModule`. Correct structure; no hidden issues.
  - **`fromTildeΓ_app_isIso_of_isLocalizedModule` (lines 364–408)** — Sorry-free. The `rw [hfun]` at line 377 and the `IsLocalizedModule.ext` application at line 404 look correct. The triangle identity invocation (`toOpen_fromTildeΓ_app`) is the expected Mathlib lemma. No issues.

---

### AlgebraicJacobian/Picard/TensorObjSubstrate.lean

- **outdated comments**: 2 flagged
- **suspect definitions**: 2 flagged (sorry-bearing load-bearing declarations)
- **dead-end proofs**: 0
- **bad practices**: 1 flagged (workflow note embedded in source code)
- **excuse-comments**: 1 flagged
- **notes**:
  - **`tensorObj_assoc_iso` docstring lines 304–305** — The docstring reads: "Status: CLOSED at the direct-`sorry` level (no `sorry` in this declaration's body); it is `sorry`-transitive only through the route-(e) residual `isLocallyInjective_whiskerLeft_of_W`." However, the declaration's body (lines 341–382) uses exclusively route-(d) methods: `W_whiskerRight_of_W` (line 370), `W_whiskerLeft_of_W` (line 373), and `isIso_sheafification_map_of_W` (lines 375–378). There is **no dependency** on `isLocallyInjective_whiskerLeft_of_W` in the body. The claim "sorry-transitive only through route-(e)" is **stale**: the body was updated to route (d) but the docstring was not. This actively misleads any reader about which file/lemma the associator depends on. Major severity.
  - **File STATUS block (lines 44–46)** — "The remaining typed-`sorry` residuals are the `⊗`-inverse lane (`exists_tensorObj_inverse`, `addCommGroup_via_tensorObj`) and the route-(e) whiskering residual `isLocallyInjective_whiskerLeft_of_W`." The route-(e) residual `isLocallyInjective_whiskerLeft_of_W` lives in Vestigial.lean (per the sub-module layout at lines 101–111). `tensorObj_assoc_iso` (the only consumer in this file that previously depended on it) now uses route-(d) and has no dependency on it. Listing the route-(e) residual as a "remaining typed-`sorry` residual" of THIS file is stale if no declaration in TensorObjSubstrate.lean is actually sorry-transitive through it. Major severity.
  - **Body comment of `tensorObj_assoc_iso` lines 344–348** — "UNCONDITIONAL (iter-238, step 0): the locally-trivial hypotheses are dropped — the body never consumed them (the whiskered-unit localizer fact holds for arbitrary modules under ROUTE (d))." This body comment accurately describes the route-(d) construction, which is consistent with the actual proof. No stale issue here — it contradicts the outdated *docstring* (lines 304–305), not itself.
  - **NEW: `sheafifyTensorUnitIso` (lines 884–918)** — Genuine, non-vacuous construction. The statement: for presheaves `P, Q` on `X`, sheafifying `P ⊗ₚ Q` is isomorphic to sheafifying `(aP).val ⊗ₚ (aQ).val`, where `a` is the sheafification functor. The proof pattern mirrors `tensorObj_assoc_iso` exactly: establish `J.W` for each unit `η.app P` and `η.app Q` via `W_toSheafify`, then whisker to get `J.W` for `η_P ▷ Q` and `(aP).val ◁ η_Q` via `W_whiskerRight_of_W` and `W_whiskerLeft_of_W`, then invert each under `a` via `isIso_sheafification_map_of_W`. The resulting composition `(@asIso _ _ _ _ _ hi1) ≪≫ (@asIso _ _ _ _ _ hi2)` correctly factors through `a(aP.val ⊗ Q)` as the intermediate. The `private` qualifier is appropriate (internal helper). No sorry, not degenerate, axiom-clean.
  - **`exists_tensorObj_inverse` (lines 693–715)** — `sorry` body at line 715. Load-bearing lemma: blocks `addCommGroup_via_tensorObj` (the `AddCommGroup` instance for the relative Picard quotient). The body comment (lines 697–714) accurately describes the open bridges (C: `dual_isLocallyTrivial`; A: SheafOfModules morphism descent) and correctly identifies the B-connector (`isIso_of_isIso_restrict`) as done. Not an excuse-comment (no "placeholder/scaffold/deferred" language); the sorry is documented as a tracked work item.
  - **`addCommGroup_via_tensorObj` (lines 1001–1005)** — `:= sorry` body at line 1005. Load-bearing `def` (the `AddCommGroup` instance for the relative Picard quotient; blocked on `exists_tensorObj_inverse`). The docstring at lines 992–994 reads: "iter-202 Lane TS scaffold: typed `sorry`. This is the iter-204+ closure target for the residual `addCommGroup` sorry of `RelPicFunctor.lean` (L235)." The phrase "scaffold: typed `sorry`" explicitly admits this is a placeholder. **Excuse-comment** on a load-bearing declaration. Severity: critical.
  - **HANDOFF comment (lines 920–972)** — The HANDOFF block is substantively honest and internally consistent. Claims marked "verified live this iter" (the abstract-left-adjoint wall, `pullbackObjUnitToUnit` Final-only iso, no sectionwise formula for the presheaf pullback) cannot be independently confirmed from source alone, but are presented with enough specificity to be plausible. The `sheafifyTensorUnitIso` claim at lines 958–964 accurately describes what the new declaration provides. **One stale/irrelevant claim**: line 971 embeds a workflow note — "(Informal agent unavailable this iter: MOONSHOT key 401, no other key set.)" — which is a runtime system status note that does not belong in source comments and will be stale immediately. Minor severity.
  - **`picCommGroup` (lines 834–861)** — The group axioms discharge correctly via the appropriate isos (`tensorObj_assoc_iso`, `tensorObj_left/right_unitor`, `tensorObj_braiding`). The `Classical.choose` / `Classical.choose_spec` pattern in `picInv` (lines 814–827) is legitimate for extracting the inverse witness from an existential; `inv_mul_cancel` at lines 852–856 is consistent with the `picInv` definition. No issues.
  - **`tensorObj_assoc_iso_invertible` (lines 742–745)** — Correctly marked as an immediate specialisation of `tensorObj_assoc_iso`; the `_hM`, `_hN`, `_hP` parameters are unused (they exist to match the blueprint statement). This is legitimate and intentional (per the body comment).
  - **`isIso_of_isIso_restrict` (lines 567–599)** — Axiom-clean. The stalkwise-iso route via `restrictStalkNatIso` + `isIso_of_stalkFunctor_map_iso` is correct; no sorry.
  - **`tensorObj_restrict_iso` (lines 446–523)** — Axiom-clean. The four-step proof (restrictFunctorIsoPullback → sheafificationCompPullback → strip sheafification → H1∘H2) is well-documented and the `letI β β' α` bindings are appropriately zeta-transparent. No issues.

---

## Must-fix-this-iter

- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:572` — `pushforward_spec_tilde_iso` body is `:= by … sorry`. Load-bearing: blocks `affineBaseChange_pushforward_iso` and hence the full flat-base-change theorem. Why must-fix: sorry on a load-bearing claim; the two newly-landed bricks (`gammaPushforwardIsoAt`, `tildeRestriction_isLocalizedModule`) are in place, meaning this is now the nearest closable gap.
- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:604` — `affineBaseChange_pushforward_iso` body is `:= by … sorry`. Substantive load-bearing theorem. Why must-fix: sorry on a substantive claim; blocks `flatBaseChange_pushforward_isIso`.
- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:617–626` — `flatBaseChange_pushforward_isIso` body is `:= by … sorry` preceded by the excuse-comment "deferred to a later iteration:" at line 619. Why must-fix: excuse-comment on a load-bearing theorem + sorry body; the "deferred" phrasing is an admission of intentional incompleteness.
- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:715` — `exists_tensorObj_inverse` body ends in `sorry`. Load-bearing: blocks `addCommGroup_via_tensorObj`. Why must-fix: sorry on a load-bearing lemma.
- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:1005` — `addCommGroup_via_tensorObj` body is `:= sorry`. The docstring at lines 992–994 contains the excuse-comment "iter-202 Lane TS scaffold: typed `sorry`." Why must-fix: excuse-comment ("scaffold") on a load-bearing `def` + `:= sorry` body.

---

## Major

- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:304–305` — `tensorObj_assoc_iso` docstring claims "it is `sorry`-transitive only through the route-(e) residual `isLocallyInjective_whiskerLeft_of_W`." The body uses route-(d) exclusively (`W_whiskerRight_of_W`, `W_whiskerLeft_of_W`, `isIso_sheafification_map_of_W`); no dependency on `isLocallyInjective_whiskerLeft_of_W` exists. The docstring is stale and actively misleads about the dependency graph of this declaration.
- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:44–46` — File STATUS block lists `isLocallyInjective_whiskerLeft_of_W` as a "remaining typed-`sorry` residual" for this file, implying it is a sorry-transitive dependency of some declaration here. As of this iter, no declaration in TensorObjSubstrate.lean is sorry-transitive through route-(e); that residual lives in Vestigial.lean and is no longer a dependency of `tensorObj_assoc_iso`. Stale documentation.

---

## Minor

- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:328–349` — `gammaPushforwardIsoAt` proof body is a near-verbatim copy of `gammaPushforwardIso` (lines 289–302), differing only in the definition of `SecN`. `gammaPushforwardIso` is a special case (with `U = ⊤`) and could be derived from `gammaPushforwardIsoAt` rather than maintaining a duplicate proof. Code-duplication risk in a tactic proof.
- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:205` — `/-!` STATUS docstring references "See `task_results` for the full attempt log" — a path to a runtime artifact directory, not a source-navigable reference. The referenced directory may not persist across project setups.
- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:971` — HANDOFF comment embeds the workflow note "(Informal agent unavailable this iter: MOONSHOT key 401, no other key set.)" Runtime system state does not belong in source comments; it will be immediately stale and confusing to future readers.

---

## Excuse-comments (called out separately)

- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:619`: "Proof strategy (Stacks 02KH, `i = 0`), deferred to a later iteration:" (attached to `flatBaseChange_pushforward_isIso`, the main flat base change theorem). Severity: critical — it is a load-bearing theorem and the comment is an explicit admission of intentional deferral.
- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:993–994`: "iter-202 Lane TS scaffold: typed `sorry`." (attached to `addCommGroup_via_tensorObj`, the `AddCommGroup` instance for the relative Picard quotient). The word "scaffold" names the code as a placeholder. Severity: critical — it is a load-bearing `def`.

---

## Severity summary

- **must-fix-this-iter**: 5 — these block downstream work in their files until addressed.
- **major**: 2 — stale docstrings in TensorObjSubstrate.lean; one actively misrepresents the dependency graph of `tensorObj_assoc_iso`.
- **minor**: 3 — proof duplication, workflow-artifact reference in a docstring, workflow note in HANDOFF.
- **excuse-comments**: 2 (also counted under must-fix-this-iter above; called out separately because they document the project lying to itself).

Overall verdict: The three new declarations (`gammaPushforwardIsoAt`, `tildeRestriction_isLocalizedModule`, `sheafifyTensorUnitIso`) are genuine, non-vacuous, and axiom-clean; `pushforward_spec_tilde_iso`'s skeleton is real with a single documented `sorry`; the critical rot is a stale `tensorObj_assoc_iso` docstring that falsely claims route-(e) dependency when the body uses route-(d), and two excuse-comments on the major load-bearing open sorries.
