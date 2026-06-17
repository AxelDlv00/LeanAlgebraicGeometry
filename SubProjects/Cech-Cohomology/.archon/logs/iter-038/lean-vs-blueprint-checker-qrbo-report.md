# Lean ↔ Blueprint Check Report

## Slug
qrbo

## Iteration
038

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/QcohRestrictBasicOpen.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
  (chapter lists `QcohRestrictBasicOpen.lean` in `% archon:covers` header; relevant nodes
  `lem:overEquivalence_isContinuous` + `lem:restrict_over_compat` + surrounding B2–B4 blocks)

---

## Per-declaration (blueprint `\lean{...}` blocks → Lean)

### `\lean{AlgebraicGeometry.Opens.overEquivalence_functor_coverPreserving, ...}` (chapter: `lem:overEquivalence_isContinuous`)

All four declarations pinned in this multi-name hint exist in the file:

| `\lean{...}` name | Exists | Signature match | Proof follows sketch |
|---|---|---|---|
| `Opens.overEquivalence_functor_coverPreserving` | yes (line 35) | yes | yes |
| `Opens.overEquivalence_inverse_coverPreserving` | yes (line 51) | yes | yes |
| `Opens.overEquivalence_functor_isContinuous` | yes (line 68, instance) | yes | yes |
| `Opens.overEquivalence_inverse_isContinuous` | yes (line 76, instance) | yes | yes |

- **Lean target exists**: yes (all four)
- **Signature matches**: yes — `CoverPreserving` for both cover-preservation theorems; `Functor.IsContinuous` for the two continuity instances. Matches the blueprint prose (pointwise-cover Grothendieck topology, `over`-topology on the over-site).
- **Proof follows sketch**: yes — blueprint says continuity follows from cover-preservation + cover-density of an equivalence's functors; Lean uses `Functor.IsCoverDense.isContinuous` exactly.
- **notes**: The blueprint proof for cover-preservation correctly predicts the `GrothendieckTopology.mem_over_iff` unfolding and the membership bookkeeping used in the Lean tactics. No surprises.

### `\lean{AlgebraicGeometry.presentationOverBasicOpen}` (chapter: `lem:presentation_over_basicOpen`)

- **Lean target exists**: yes (line 129)
- **Signature matches**: yes — takes `M : (Spec R).Modules`, `U : (Spec R).Opens`, a `Presentation` of `M.over U`, `g : R`, and `hg : specBasicOpen g ≤ U`; returns `(M.over (specBasicOpen g)).Presentation`. Matches the blueprint statement exactly.
- **Proof follows sketch**: yes — blueprint says to use `pushforwardPushforwardEquivalence` + `Presentation.map` + `Presentation.ofIsIso`; the Lean proof does exactly that (with `pushforwardPushforwardEquivalence` via `Over.iteratedSliceEquiv`, `.map`, then `Presentation.ofIsIso`).
- **notes**: Pre-existing (before this iter). Clean. `\leanok` is set in the blueprint. ✓

### `\lean{AlgebraicGeometry.overBasicOpenIsoRestrict}` (chapter: `lem:restrict_over_compat`)

- **Lean target exists**: **NO** — `overBasicOpenIsoRestrict` is not defined anywhere in `QcohRestrictBasicOpen.lean` or any other project file.
- **Signature matches**: N/A (declaration absent)
- **Proof follows sketch**: N/A
- **notes**: The blueprint correctly marks this `% NOTE: to-build (Route B, step B3)` and carries no `\leanok`. The `\lean{}` pin names the **intended future declaration** (the assembled B3 bridge isomorphism). What WAS built this iter is `modulesOverBasicOpenEquivalence` (the B3b engine equivalence), which is a strict sub-step toward `overBasicOpenIsoRestrict`; the TODO block comment at Lean lines 242–265 describes the remaining work (B3c transport + ring-sheaf equality) to close the gap. See **Coverage gaps** below.

### `\lean{AlgebraicGeometry.presentationModulesRestrictBasicOpen}` (chapter: `lem:presentation_modulesRestrictBasicOpen`)

- **Lean target exists**: **NO** — not defined in the file.
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Blueprint marks it `% NOTE: to-build (Route B, step B4)`, no `\leanok`. Blocked on B3 (`overBasicOpenIsoRestrict`). Not built this iter; expected.

### Pre-existing declarations (all confirmed green)

| `\lean{...}` name | Blueprint node | Status |
|---|---|---|
| `AlgebraicGeometry.specBasicOpen` | `def:spec_basic_open` | ✓ `\leanok` |
| `AlgebraicGeometry.specAwayToSpec` | `lem:spec_away_to_spec` | ✓ `\leanok` |
| `AlgebraicGeometry.modulesRestrictBasicOpen` | `lem:modules_restrict_basicOpen` | ✓ NOTE only (root import gap) |
| `AlgebraicGeometry.modulesRestrictBasicOpenIso` | same | ✓ same |
| `AlgebraicGeometry.specAwayToSpec_eq` | `lem:spec_away_to_spec_eq` | ✓ `\leanok` |

---

## Red flags

*No must-fix findings.* No `sorry`, no axiom declarations, no placeholder bodies, no excuse-comments on
live declarations, no `Classical.choice` on non-trivial claims in any of the 8 new decls.

The TODO block comment at lines 242–265 is a planning note for the **next** declaration
(`overBasicOpenIsoRestrict`, iter-039); it is clearly labelled "TODO (Route B, step B3 object iso + B4 —
next iteration)" and is attached to no currently-wrong declaration. It is **not** an excuse-comment for
bad code — it documents the remaining path forward for a declaration that doesn't exist yet.

---

## Unreferenced declarations (informational)

The 8 new declarations this iter and their blueprint-coverage status:

| Declaration | Lines | Blueprint reference | Classification |
|---|---|---|---|
| `specBasicOpen_ι_image_overEquivalence_functor` (private) | 155–158 | none | helper — private, expected |
| `overEquivalence_functor_isContinuous_toScheme` | 162–166 | none | sub-instance of `lem:overEquivalence_isContinuous` entry; minor |
| `overEquivalence_inverse_isContinuous_toScheme` | 169–173 | none | same; minor |
| `overForgetIso` | 179–184 | described in B3a proof prose only | B3a sub-step helper |
| `overBasicOpenRingHom` | 189–195 | described in B3a proof prose only | B3a sub-step helper |
| `overForgetInvIso` | 200–203 | described in B3a proof prose only | B3a sub-step helper |
| `overBasicOpenRingInvHom` | 207–213 | described in B3a proof prose only | B3a sub-step helper |
| `modulesOverBasicOpenEquivalence` | 222–240 | described in B3b proof prose; **no `\lean{}` pin** | **coverage debt — major** |

The four B3a helpers (`overForgetIso`, `overForgetInvIso`, `overBasicOpenRingHom`,
`overBasicOpenRingInvHom`) are described in the proof sketch of `lem:restrict_over_compat` by their
mathematical roles (φ, ψ, H₁, H₂), and their omission from `\lean{}` pins is acceptable for internal
sub-steps. Similarly the two `..._isContinuous_toScheme` instances are technical instance-search plumbing
that delegate immediately to the corresponding `Opens.overEquivalence_*` instances in
`lem:overEquivalence_isContinuous`.

`modulesOverBasicOpenEquivalence` is a different matter — it is the **central new deliverable of this
iter**, a self-contained equivalence of module categories built from `pushforwardPushforwardEquivalence`.
It maps to step B3b in the blueprint's proof sketch but has no `\lean{}` pin of its own, so
`sync_leanok` cannot track it and the blueprint does not officially record this milestone.

---

## Blueprint adequacy for this file

- **Coverage**: 10 of 18 Lean declarations have a corresponding `\lean{...}` block. Of the 8 without:
  5 are helpers (private or thin sub-instances), 1 is `modulesOverBasicOpenEquivalence` (substantive,
  should be pinned), and 2 future planned decls are correctly marked `% NOTE: to-build` and have
  `\lean{}` pins that are intentionally forward-looking.

- **Proof-sketch depth**: **adequate** for what was formalized. The B3a/B3b/B3c decomposition in
  `lem:restrict_over_compat` correctly predicts:
  - B3a: the functor iso (`overForgetIso`), ring-sheaf comparisons φ, ψ, and coherence witnesses
  - B3b: feeding into `pushforwardPushforwardEquivalence` to get the module equivalence
  - B3c: transport to `Spec Rg` (correctly identified as the remaining future step)
  
  The TODO block in the Lean file (lines 242–265) is mathematically consistent with the blueprint's
  B3c description: it states the same `pushforwardCongr h` reduction + `ι_appIso` ring-sheaf equality
  path that the blueprint's proof text implies.

- **Hint precision**: **adequate with one gap**. The four decls in `lem:overEquivalence_isContinuous`
  are pinned precisely. The `\lean{overBasicOpenIsoRestrict}` pin on `lem:restrict_over_compat` is the
  correct future target (B3 bridge iso), not the engine (`modulesOverBasicOpenEquivalence`). The gap is
  the absence of a `\lean{modulesOverBasicOpenEquivalence}` pin anywhere.

- **Generality**: matches need — all declarations are parameterized correctly (`{R : CommRingCat.{u}}`,
  `(f : R)`, etc.).

- **Prose vs Lean technique (B3a)**: The blueprint says the comparison morphisms φ, ψ are built from
  `ι.appIso` of the open immersion. The Lean uses `overForgetIso` (a functor-level naturality iso based
  on `ι ''ᵁ (ι ⁻¹ᵁ V) = V`) and whiskers it into the ring sheaf. These are mathematically equivalent
  routes — the functor iso composed with the structure-sheaf map gives the same comparison as `appIso`.
  The `ι_appIso` appears in the plan for B3c (the TODO block). This is a **minor** prose-vs-Lean
  technique difference, not a correctness issue.

- **Recommended chapter-side actions** (for the blueprint-writing subagent next iter):
  1. **Major**: Add a `\lean{AlgebraicGeometry.modulesOverBasicOpenEquivalence}` pin. The natural
     location is either (a) within the proof block of `lem:restrict_over_compat` via an explicit
     `\lean{...}` inside the B3b step description, or (b) as a separate intermediate definition block
     `\begin{definition}[B3b engine equivalence]\label{def:modules_over_basicOpen_equivalence}` before
     `lem:restrict_over_compat`. Option (b) is preferred since it gives `sync_leanok` a trackable
     node and separates the engine from the assembled bridge.
  2. **Minor**: Consider adding `\lean{AlgebraicGeometry.overEquivalence_functor_isContinuous_toScheme,
     AlgebraicGeometry.overEquivalence_inverse_isContinuous_toScheme}` to the proof block of
     `lem:overEquivalence_isContinuous` with a one-line remark explaining these are the specialized
     `toScheme`-typed instances needed by `pushforwardPushforwardEquivalence`'s instance search in the
     B3b context. Not blocking.

---

## Severity summary

| Finding | Severity |
|---|---|
| `\lean{overBasicOpenIsoRestrict}` on `lem:restrict_over_compat` names a not-yet-built decl | **major** — dangling `\lean{}` pin; mitigated by `% NOTE: to-build` + no `\leanok`; requires a new `\lean{}` pin when the decl is built |
| `modulesOverBasicOpenEquivalence` has no `\lean{}` pin | **major** — central new B3b deliverable untracked by blueprint; `sync_leanok` cannot see it |
| `overEquivalence_*_isContinuous_toScheme` have no `\lean{}` pins | **minor** — technical plumbing sub-instances, informational only |
| B3a prose says "built from `ι.appIso`"; Lean uses `overForgetIso` whisker technique | **minor** — mathematically equivalent routes, `appIso` deferred to B3c |
| No sorry, no axioms, no placeholder bodies in any of the 8 new declarations | ✓ clean |

**Overall verdict**: The 8 new declarations are all axiom-clean with no red flags; the formalization faithfully executes the B3a/B3b steps described in the blueprint's `lem:restrict_over_compat` proof sketch. Two major adequacy gaps: (1) the `\lean{overBasicOpenIsoRestrict}` pin on `lem:restrict_over_compat` is aspirational (planned next iter, correctly marked `% NOTE: to-build`), and (2) `modulesOverBasicOpenEquivalence` — the central B3b engine built this iter — lacks any `\lean{}` pin in the blueprint, leaving it invisible to `sync_leanok`. No must-fix findings; both major gaps require blueprint-writer attention in iter-039.
