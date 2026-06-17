# Lean Audit Report

## Slug
ts228

## Iteration
228

## Scope
- files audited: 1 (`AlgebraicJacobian/Picard/TensorObjSubstrate.lean`)
- files skipped (per directive): all others — directive narrows scope to one file

---

## Per-file checklist

### `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`

- **outdated comments**: 3 flagged (accumulated iter-number narrative; one misleading `sorry` prose mismatch)
- **suspect definitions**: 1 flagged (unused hypotheses in `tensorObj_assoc_iso`)
- **dead-end proofs**: 0
- **bad practices**: 1 flagged (deprecated `CategoryTheory.Sheaf.val` API, 15+ instances, 2 in new decls)
- **excuse-comments**: 0
- **notes**:

  #### Focus declarations (L1558, L1603, L1698)

  **`dualPrecompEquiv` (L1558–1595)**
  - Statement: correct. Sectionwise `R(U)`-linear equivalence
    `(restr U M' ⟶ restr U 𝟙_) ≃ₗ (restr U M ⟶ restr U 𝟙_)` induced by
    pre-composition with the restriction of `e.hom / e.inv` to `Over U`.
    Direction matches the contravariance stated in the docstring.
  - Proof fields: `map_add'` = `Preadditive.comp_add` ✓; `map_smul'` = `(Category.assoc _ _ _).symm` — valid because the `homModule` scalar action is post-composition (`r • φ = φ ≫ globalSMul r`), so `e.hom|_U ≫ (φ ≫ globalSMul r) = (e.hom|_U ≫ φ) ≫ globalSMul r` by associativity ✓; inverses by `← Category.assoc, ← Functor.map_comp, e.{inv_hom_id,hom_inv_id}` ✓.
  - No `sorry`, no axioms. LSP: no diagnostics on this declaration.
  - Minor: docstring says the scalar action "commutes with this pre-composition" — technically it *reassociates through* it (not a commutativity identity). Low impact, but imprecise.

  **Presheaf `PresheafOfModules.dualIsoOfIso` (L1603–1608)**
  - Statement: `dual M' ≅ dual M` from `e : M ≅ M'`. Correct contravariant direction.
  - Proof: `PresheafOfModules.isoMk (fun U => (dualPrecompEquiv e U.unop).toModuleIso)` —
    one argument. Verified via `lean_hover_info`: `isoMk`'s `naturality` field has
    `default := by cat_disch`, so the second argument is legally omitted when `cat_disch`
    can close it. LSP reports no error.
  - Docstring: accurate. Claim "`\leanok`-ready" is correct (no sorry in this decl).
  - Minor: the single-arg call silently relies on `cat_disch` closing naturality, which is
    non-obvious to readers — nearby `pushforwardCongr` at L932 provides naturality explicitly
    and serves as a confusing contrast.
  - No `sorry`, no axioms.

  **Sheaf `AlgebraicGeometry.Scheme.Modules.dualIsoOfIso` (L1698–1702)**
  - Statement: `dual M' ≅ dual M` from `e : M ≅ M'` in `X.Modules`. Correct.
  - Proof: applies `sheafification.mapIso` to `PresheafOfModules.dualIsoOfIso` of
    `(SheafOfModules.forget).mapIso e`. Mirrors `tensorObjIsoOfIso` exactly as the
    docstring claims ✓.
  - Docstring: accurate.
  - Two deprecation warnings at L1700 (`Sheaf.val` deprecated; see below). Same pattern
    as the pre-existing `Scheme.Modules.dual` at L1688.
  - No `sorry`, no axioms.

  #### Sorry inventory (3 total)

  - **L659** — `isLocallyInjective_whiskerLeft_of_W`: sorry with a multi-paragraph comment
    enumerating gaps (d.1-bridge + d.2 stalk-⊗ commutation). Comment is accurate — these
    are the correct residuals, and the iter-214 correction note (adding `stalkLinearMap`
    infra) is documented correctly. No inaccuracy.
  - **L2143** — `exists_tensorObj_inverse`: sorry with in-body comment citing two remaining
    bridges (C = `dual_isLocallyTrivial`, A = `homOfLocalCompat`). Comment correctly notes
    B-bridge (`isIso_of_isIso_restrict`, L2062) is done. Reference verified: L2062 has no
    sorry. Comment also correctly labels the "forbidden sheafify-the-presheaf-eval shortcut"
    as a dead end. Accurate.
  - **L2208** — `addCommGroup_via_tensorObj`: sorry. Docstring explains this is the
    iter-204+ closure target depending on `exists_tensorObj_inverse`. Accurate.

  #### Pre-existing file-wide issues (not introduced by iter-228 new decls)

  - **Deprecated API** (`Sheaf.val`): `CategoryTheory.Sheaf.val` is deprecated in favour of
    `ObjectProperty.obj`; 15 Lean warnings (lines 1632, 1648, 1688, 1700, 1735, 1752, 1754,
    1764, 1766, 1774, 1776, 1784, 1844, 1847, 1852, 1871, 1873). The iter-228 declarations
    add two new instances at L1688 (in `Scheme.Modules.dual`) and L1700 (in
    `Scheme.Modules.dualIsoOfIso`), following the pre-existing file pattern.

  - **`tensorObj_assoc_iso` unused hypotheses** (L1835–1836): Lean warns `unused variable`
    on `hM`, `hN`, `hP : LineBundle.IsLocallyTrivial`. The inline comment at L1839–1841
    discloses this intentionally: "the locally-trivial hypotheses are not even consumed...
    but are retained to match the blueprint pin." While disclosed, the result is that the
    proof is valid for *arbitrary* `M, N, P` — the signature overstates the precondition,
    which could mislead downstream users who think they need to establish local triviality
    before calling this.

  - **Narrative/historical comment accumulation**: The module docstring header (L38–54) and
    several proof-body comments carry explicit iter-number references (iter-206, -212, -214,
    -217, -218, -219, -220, -221, -222, -223, -224, -226). These document project history
    but add noise; particularly, the iter-222/223 heartbeat-bomb diagnosis in the proof body
    of `internalHomEval` (L1514–1518) is a debugging note that will confuse future readers.

  - **`isLocallySurjective_whiskerLeft`** (L368): linter warns `` `ext` did not consume the
    patterns `r` ``. Pre-existing, cosmetic.

  - **Long lines** at L1498, 1501, 1504, 1505, 1517, 1999, 2000, 2001 (style linter warnings
    >100 chars). Pre-existing, in proof bodies.

---

## Must-fix-this-iter

None. The three new declarations are axiom-clean, correctly typed, and their docstrings are
accurate. No sorry was introduced. No excuse-comments found. No weakened or parallel-API
definitions.

---

## Major

- `TensorObjSubstrate.lean:1700` (and 1688) — `CategoryTheory.Sheaf.val` is deprecated
  (Lean warns: "use `ObjectProperty.obj`"). The two new declarations at L1688 and L1700
  each trigger this warning, following the pre-existing pattern at 13 other call sites.
  The whole-file migration to `ObjectProperty.obj` is overdue; every new declaration that
  copies the `.val` pattern extends the debt.

- `TensorObjSubstrate.lean:1835–1836` — `tensorObj_assoc_iso` declares hypotheses
  `hM hN hP : LineBundle.IsLocallyTrivial` that Lean's linter confirms are *unused* in the
  proof body. The docstring discloses this ("retained to match the blueprint pin"), but the
  effect is that the signature misleads: the proof is actually valid for arbitrary
  `M N P : X.Modules`. Callers who do not have `IsLocallyTrivial` will be incorrectly
  blocked. The declaration is noted as unprotected, so the signature can be weakened to
  drop the hypotheses without breaking the blueprint pin.

---

## Minor

- `TensorObjSubstrate.lean:1555` — `dualPrecompEquiv` docstring says the `R(U)`-action
  "commutes with this pre-composition." The correct characterisation is that
  pre-composition *associatively reassociates* with the post-composition scalar action; it
  is not a commutativity identity. Misleads a first-time reader of the linearity proof.

- `TensorObjSubstrate.lean:1603` — Presheaf `dualIsoOfIso` silently relies on `cat_disch`
  to close the `isoMk` naturality argument. The nearby `pushforwardCongr` at L932 provides
  naturality explicitly, creating an inconsistent reading experience. A one-line comment
  noting the default tactic would suffice.

- `TensorObjSubstrate.lean:38–54` (module header) + throughout proof bodies — accumulated
  multi-iteration narrative (explicit iter-numbers, diagnostic history such as the
  iter-222/223 heartbeat-bomb note at L1514–1518). These are not wrong but will become
  misleading as the codebase evolves.

- `TensorObjSubstrate.lean:368` — `ext` unused `rcases` pattern `r` (style linter warning).
  Pre-existing; cosmetic.

---

## Excuse-comments (always called out separately)

None found.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 2 (deprecated `Sheaf.val` API in new and pre-existing declarations;
  `tensorObj_assoc_iso` signature/proof mismatch with unused hypotheses)
- **minor**: 4 (docstring imprecision; undocumented `cat_disch` reliance; narrative clutter;
  style linter)
- **excuse-comments**: 0

Overall verdict: the three iter-228 additions (`dualPrecompEquiv`, presheaf `dualIsoOfIso`,
sheaf `dualIsoOfIso`) are correct, axiom-clean, and accurately documented. The file's main
technical debt — deprecated `Sheaf.val` API (15 instances, 2 in new decls) and the
overspecified `tensorObj_assoc_iso` signature — are pre-existing and not introduced this
iter, but both merit cleanup before the sorry count drops further.
