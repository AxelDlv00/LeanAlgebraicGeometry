# Session 38 (iter-038) — review summary

## Metadata
- **Session / iter**: 38 / iter-038
- **Sorry count**: 2 → 2 (no regression). Both frozen/superseded: `CechAcyclic.affine` (dead, line 110)
  + `CechHigherDirectImage.lean` (frozen P5b). The prover file `QcohRestrictBasicOpen.lean` is 0-sorry.
- **Build**: GREEN. `lake env lean AlgebraicJacobian/Cohomology/QcohRestrictBasicOpen.lean` EXIT 0.
- **Lanes**: planned 1, ran 1 (`mathlib-build`, `QcohRestrictBasicOpen.lean`).
- **+8 axiom-clean decls**; 0 new sorries.
- **dag-query**: gaps = 0, unmatched = 9 (1 pre-existing dead `CechAcyclic.affine` + 8 new this-iter decls).

## Target: Route B step B3 — `QcohRestrictBasicOpen.lean`

### SOLVED — `modulesOverBasicOpenEquivalence` (the B3b engine equivalence)
The single load-bearing lane of Route B (per `analogies/bridge.md`). Built axiom-clean:

`modulesOverBasicOpenEquivalence (g) : (specBasicOpen g).toScheme.Modules ≌ SheafOfModules ((Spec R).ringCatSheaf.over (specBasicOpen g))`

via `pushforwardPushforwardEquivalence (Opens.overEquivalence (specBasicOpen g)) φ ψ H₁ H₂`, plus the 7
supporting decls: `overEquivalence_functor/inverse_isContinuous_toScheme` (instance defeq re-statements
for the `toScheme` carrier so instance search fires), `specBasicOpen_ι_image_overEquivalence_functor`
(private; image–preimage identity `ι ''ᵁ (ι⁻¹ᵁ V) = V` via `Set.image_preimage_eq_of_subset`),
`overForgetIso`, `overForgetInvIso` (= `Iso.refl`, the reverse datum is definitional),
`overBasicOpenRingHom` (φ), `overBasicOpenRingInvHom` (ψ).

**Key enabling discoveries:**
- `Scheme.Opens.ι_appIso = Iso.refl` (Mathlib `Restrict.lean:98`): the open-immersion structure-sheaf
  comparison is the identity — the bridge is `eqToHom`/identity-class, not genuinely twisted.
- `toScheme_presheaf_obj/_map` are `rfl`: both ring sheaves factor through `(Spec R).ringCatSheaf.val`
  definitionally, so φ/ψ are just whiskerings of `overForgetIso.inv` / `overForgetInvIso.inv`.
- Naturality of `overForgetIso` is automatic (`Over (Opens X)` is a thin/poset category).

### KERNEL-SOUNDNESS TRAP (caught and fixed by the prover)
The two coherence obligations H₁/H₂ were initially attacked with a bare `ext (V : …)` (and once
`congr 1`). The LSP reported the goal **solved**, but `lake env lean` rejected the produced term with
`error: unknown free variable _fvar.153949` — i.e. `ext`/`congr 1` auto-closed via an **unsound rfl-term**
the kernel will not accept. The prover correctly diagnosed this and rewrote both obligations as explicit
terms:
```
refine NatTrans.ext (funext fun (V : (Opens ↥(specBasicOpen g))ᵒᵖ) => ?_)   -- H₁ index; H₂ uses (Over …)ᵒᵖ
simp only [testPhi, testPsi, NatTrans.comp_app, Functor.whiskerRight_app, …]
erw [← Functor.map_comp]
exact congrArg (Spec R).ringCatSheaf.val.map (Subsingleton.elim _ _)        -- thin-Opens uniqueness
-- H₂ closes with (congrArg … (Subsingleton.elim _ (𝟙 _))).trans (map_id _)
```
Final state: `lake env lean` EXIT 0; `#print axioms` on all 8 new decls = `[propext, Classical.choice,
Quot.sound]`. **Independently re-verified by the review agent** (axiom check on the 7 public decls; the
private helper is inaccessible by name, expected). The lean-auditor confirmed the `Subsingleton.elim`
proofs are genuine, non-vacuous (thin-category argument), with no surviving spurious-rfl.

### PARTIAL — `overBasicOpenIsoRestrict` (B3 object iso, the `\lean{}`-pinned named target)
NOT built — left as a precise in-file TODO (a comment, **not** a sorry). `(SheafOfModules.pushforwardCongr
?_).app M` typechecks against the exact target but leaves the site functor `F` a **stuck metavariable**
(`Functor.IsContinuous ?F …`); the two candidate functors are defeq, not syntactic. Remaining work: supply
φ/ψ/F explicitly, prove the ring-sheaf data equality `h` via `ext` + `ι_appIso`. B4
(`presentationModulesRestrictBasicOpen`) is mechanical after it. No mathematical wall remains on Route B.

## Key findings / patterns
- **`pushforwardPushforwardEquivalence` for restrict↔over bridges**: when both ring sheaves factor
  through the same `ringCatSheaf.val` definitionally and the open-immersion `appIso` is `Iso.refl`, the
  comparison data φ/ψ reduce to whiskerings of a functor-level naturality iso (`overForgetIso`) whose
  components are `eqToIso` of an image–preimage identity, with naturality free in the thin `Opens` category.
- **Thin-category coherence via `Subsingleton.elim`**: H₁/H₂-style coherence squares over `Opens`/`Over
  (Opens X)` close by `erw [← Functor.map_comp]` then `Subsingleton.elim` on the merged morphism — but
  must be written as an explicit term, NOT auto-closed by `ext`/`congr 1` (kernel-soundness trap below).
- **`ext`/`congr 1` kernel-soundness trap**: these tactics can auto-close a thin-category goal with a
  term the LSP accepts but the kernel rejects (`unknown free variable _fvar…`). ALWAYS confirm with
  `lake env lean`, never trust the LSP's "solved". Use explicit `NatTrans.ext`/`congrArg`/`Subsingleton.elim`.

## Reviewer findings (full reports linked; no must-fix)
- **lean-auditor** (`task_results/lean-auditor-iter038.md`): 0 must-fix, 1 major, 5 minor. All 8 decls
  axiom-clean and genuine; coherence proofs non-vacuous. Major = pervasive deprecated `CategoryTheory.Sheaf.val`
  (5 sites: lines 195, 213, 232, 239, 240) → migrate to `ObjectProperty.obj` before next Mathlib bump.
- **lean-vs-blueprint-checker** (`task_results/lean-vs-blueprint-checker-qrbo.md`): 0 red flags, 2 major
  adequacy gaps (both blueprint coverage, planner-actionable): (1) `modulesOverBasicOpenEquivalence` (the
  central B3b deliverable) has no `\lean{}` pin → invisible to sync_leanok; (2) `\lean{overBasicOpenIsoRestrict}`
  on `lem:restrict_over_compat` names a not-yet-built decl (correctly `% NOTE: to-build`, no `\leanok`).

## Blueprint markers updated (manual)
- `Cohomology_CechHigherDirectImage.tex`, `lem:restrict_over_compat`: extended the existing `% NOTE:` to
  record that step B3b is DONE (engine `modulesOverBasicOpenEquivalence`, axiom-clean), that the
  `\lean{overBasicOpenIsoRestrict}` pin is the remaining B3c object iso (not yet built), and that the
  planner should give the engine its own trackable node. No `\leanok` touched (sync ran iter 38, +0/−2).
  No `\mathlibok` added (all 8 new decls are project theorems, not Mathlib re-exports). No `\lean{}`
  rename (the pinned target is unbuilt, not renamed).

## Low-severity notes
- Auditor minor: `show` vs `change` at line 46; 8 long lines (>100 chars); `overForgetInvIso = Iso.refl`
  fragility (Lean-verified, but invisible to reader); `set_option backward.isDefEq.respectTransparency
  false` scoped to pre-existing `presentationOverBasicOpen`; 24-line in-file TODO block (accurate, just long).

## Recommendations
See `recommendations.md`. Headline: continue B3 next iter (`overBasicOpenIsoRestrict`) — bounded mechanical
step, recipe in the file TODO; planner should add a `def:modules_over_basicOpen_equivalence` blueprint node
+ migrate `Sheaf.val` → `ObjectProperty.obj`.
