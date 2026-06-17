# Lean ↔ Blueprint Check Report

## Slug
di252

## Iteration
252

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean`
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`
  (dual-inverse / hom-of-local-compat blocks, §sec:tensorobj_dual_infra, lines ≈5354–5719)

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.dual_restrict_iso}` (chapter: `\lem:dual_restrict_iso`, line 5359)
- **Lean target exists**: yes — `DualInverse.lean:230`
- **Signature matches**: yes — `{X Y : Scheme.{u}} (f : Y ⟶ X) [IsOpenImmersion f] (M : X.Modules) : (dual M).restrict f ≅ dual (M.restrict f)` matches the blueprint statement exactly.
- **Proof follows sketch**: partial — Steps 1–3 + H1-bridge match the blueprint's four-step recipe. One `sorry` remains at the identified Step-4 presheaf residual `(pushforward β).obj (dual M.val) ≅ dual ((pushforward β).obj M.val)`, which is the frontier explicitly described in the blueprint proof (Leg A + Leg B, §dual_restrict_iso proof). The `sorry` is correctly placed at the one unresolved ingredient; no dishonest elision.
- **Notes**: The blueprint proof marks this `\leanok` on the statement block (declaration compiles with sorry). Proof block has no `\leanok` — consistent with the outstanding sorry. No excuse-comments; in-file module doc accurately records the step-4 residual. Status is transparent and blueprint-aligned.

### `\lean{AlgebraicGeometry.Scheme.Modules.dual_unit_iso}` (chapter: `\lem:dual_unit_iso`, line 5476)
- **Lean target exists**: yes — `DualInverse.lean:274`
- **Signature matches**: yes — `dual (SheafOfModules.unit Y.ringCatSheaf) ≅ SheafOfModules.unit Y.ringCatSheaf` matches the blueprint.
- **Proof follows sketch**: partial match — mathematical content matches (eval-at-1 isomorphism, then sheafify). Route differs: blueprint says "composed with the left unitor `lem:tensorobj_unit_iso`"; Lean uses `unitDualSectionEquiv` built via `globalSMul` inverse directly, with no left-unitor invocation. The `\uses{}` in the blueprint lists `lem:tensorobj_unit_iso` but the Lean proof does not depend on it. Mathematical conclusion is the same; proof sketch diverges.
- **Notes**: `dual_unit_iso` compiles with no sorry (axiom-clean). Blueprint proof block lacks `\leanok` — minor sync_leanok timing issue or genuine gap; should be resolved by next sync. The left-unitor route vs. globalSMul route is a minor sketch divergence, acceptable under the "mathematical content match" rule.

### `\lean{AlgebraicGeometry.Scheme.Modules.dual_isLocallyTrivial}` (chapter: `\lem:dual_isLocallyTrivial`, line 5508)
- **Lean target exists**: yes — `DualInverse.lean:332`
- **Signature matches**: yes — `{X : Scheme.{u}} {L : X.Modules} (hL : LineBundle.IsLocallyTrivial L) : LineBundle.IsLocallyTrivial (dual L)` matches the blueprint.
- **Proof follows sketch**: yes — exact three-step chain `dual_restrict_iso ≪≫ (dualIsoOfIso eL).symm ≪≫ dual_unit_iso` matches blueprint items 1–3 (C-bridge, contravariant dualIsoOfIso, then dual_unit_iso). The `(dualIsoOfIso eL).symm` in Lean correctly applies the `.symm` since `eL : L.restrict U.ι ≅ SheafOfModules.unit _` (covariant iso) and `dualIsoOfIso` is contravariant. Blueprint describes the `dualIsoOfIso` step as inducing `dual(L|U) ≅ dual O_U` which matches.
- **Notes**: No sorry in the body; transitively inherits the `dual_restrict_iso` step-4 sorry, which is expected and blueprint-authorized. `\leanok` on statement block is correct.

### `\lean{AlgebraicGeometry.Scheme.Modules.homOfLocalCompat}` (chapter: `\lem:sheafofmodules_hom_of_local_compat`, line 5629)
- **Lean target exists**: yes — `DualInverse.lean:474`
- **Signature matches**: yes — type signature matches the blueprint statement (cover `U`, cover-exhaustion `hU`, local morphisms `f`, HEq compatibility `hf`, returning a global morphism `M ⟶ N`). The use of `HEq` for the compatibility condition matches the blueprint's discussion of propositional-but-not-definitional equality.
- **Proof follows sketch**: partial — Step (i) setup (constructing the sheaf `H`, proving `iSup U = ⊤`, invoking `homLocalSection U f`, calling `existsUnique_gluing`) is complete and compiling. One `sorry` remains for sub-steps (a) `IsCompatible`, (b) `presheafHomSectionsEquiv` conversion, and (c) `homMk` linearity — exactly the residual three pieces the blueprint names.
- **Notes**: `\leanok` on statement block correct. The load-bearing naturality field is done (in `homLocalSection`). The `sorry` comment in the file is accurate documentation, not an excuse.

---

## Red flags

### Placeholder / suspect bodies
None that are not blueprint-authorized.

- `dual_restrict_iso` at `DualInverse.lean:256` — `sorry` at Step-4, but this is the precisely-identified frontier described in the blueprint proof (Legs A+B of the presheaf residual). Not a fake statement; declaration compiles and represents genuine partial proof.
- `homOfLocalCompat` at `DualInverse.lean:510` — `sorry` at the gluing assembly residual, with accurate in-file comment. The load-bearing piece (`homLocalSection`) is now axiom-clean. Not a fake statement.

### Excuse-comments
None. Module-level doc notes ("PARTIAL", "TRANSITIVELY PARTIAL", "OPEN") are accurate progress tracking, not excuses for wrong code.

### Axioms / Classical.choice on non-trivial claims
None found.

---

## Unreferenced declarations (informational)

These declarations in `DualInverse.lean` have no corresponding `\lean{...}` block in the blueprint:

| Declaration | Namespace | Status |
|---|---|---|
| `unitDualSectionEquiv` | `PresheafOfModules` | Helper only — sectionwise `LinearEquiv` that feeds `dualUnitIsoGen`. Blueprint doesn't need to track this level. |
| `dualUnitIsoGen` | `PresheafOfModules` | Helper only — the presheaf-level `dual 𝟙_ ≅ 𝟙_`. Could be promoted; see below. |
| `presheafDualUnitIso` | `AlgebraicGeometry.Scheme.Modules` | Thin wrapper (`dualUnitIsoGen` at the scheme's presheaf). Pure alias. |
| **`homLocalSection`** | `AlgebraicGeometry.Scheme.Modules` | **NOT a helper.** This is the load-bearing sub-lemma that the blueprint explicitly calls out as the "genuine coherence risk" of `homOfLocalCompat` and directs building first as "a standalone axiom-clean lemma." The blueprint prose uses the name `localSection` throughout the `homOfLocalCompat` proof sketch but provides NO `\lean{...}` tag. **Flag as MAJOR — see below.** |

---

## Blueprint adequacy for this file

- **Coverage**: 4/8 Lean declarations have a `\lean{...}` block (`dual_restrict_iso`, `dual_unit_iso`, `dual_isLocallyTrivial`, `homOfLocalCompat`). The 4 unreferenced declarations include 3 pure helpers (acceptable) and **1 substantive sub-lemma** (`homLocalSection`) that the blueprint describes as load-bearing.

- **Proof-sketch depth**: **adequate** overall, with one concrete gap:
  - `lem:dual_restrict_iso` — detailed four-step recipe (Legs A and B, slice-reindexing + ring-iso transport); substantive enough to guide the remaining Step-4 work.
  - `lem:dual_unit_iso` — adequate: evaluation-at-1 route is described; minor mismatch (left-unitor composition mentioned but not required by the Lean route).
  - `lem:dual_isLocallyTrivial` — adequate; three-step chain spelled out.
  - `lem:sheafofmodules_hom_of_local_compat` — adequate at the conceptual level, but **under-specified on the `hf` (HEq) → `IsCompatible` bridge** for step (a): the blueprint says the IsCompatible condition "is exactly the assumed agreement of f_i and f_j" but gives no Lean-visible recipe for translating the HEq-typed hypothesis into the positional `IsCompatible` structure. This is the crux of the remaining sorry and the blueprint doesn't show the path.

- **Hint precision**: **loose in one place** — `homLocalSection` is described by the informal name `localSection` throughout the blueprint's `lem:sheafofmodules_hom_of_local_compat` proof sketch, but no `\lean{...}` tag pins the Lean declaration. A prover reading the chapter would know to build this but would have to guess the Lean identifier.

- **Generality**: matches need.

- **Recommended chapter-side actions**:
  1. **Add `\lean{AlgebraicGeometry.Scheme.Modules.homLocalSection}` tag** to the `lem:sheafofmodules_hom_of_local_compat` proof (or add a dedicated `\begin{definition}` or `\begin{lemma}` block for `localSection` immediately before `lem:sheafofmodules_hom_of_local_compat`). The blueprint already treats this as a named sub-piece; it just needs the Lean tag.
  2. **Expand step (a) of `lem:sheafofmodules_hom_of_local_compat` proof**: give a concrete recipe for translating `hf : ∀ i j, HEq …` into `IsCompatible H.1 U (homLocalSection U f)` — specifically, explain how the HEq comparison of double-restriction routes becomes the equality of `homLocalSection` local sections on the overlap (via `homLocalSection` naturality + `Subsingleton.elim` on `Opens X` morphisms). This is the piece the prover will need for the remaining sorry.
  3. **Optional**: add a `\lean{AlgebraicGeometry.Scheme.Modules.presheafDualUnitIso}` (or `PresheafOfModules.dualUnitIsoGen`) note to the `lem:dual_unit_iso` proof body, since the implementation diverges from the left-unitor route stated in the sketch. Keeps chapter and code in sync for future maintainers.
  4. **Optional**: update the `lem:dual_unit_iso` proof `\uses{}` to drop `lem:tensorobj_unit_iso` (the Lean proof doesn't use it) and keep it honest, or keep it as an equivalent route note.

---

## Severity summary

| Finding | Severity |
|---|---|
| `homLocalSection` axiom-clean but no `\lean{...}` tag in blueprint | **major** — blueprint explicitly names it as load-bearing, Lean has it, chapter doesn't pin it |
| `lem:sheafofmodules_hom_of_local_compat` proof under-specified on HEq → IsCompatible bridge | **major** — this is the remaining sorry's exact blocker; the blueprint's prose does not show the path |
| `dual_restrict_iso` sorry at Step-4 | not a red flag — blueprint-authorized frontier |
| `dual_isLocallyTrivial` transitive sorry via `dual_restrict_iso` | not a red flag — expected |
| `homOfLocalCompat` sorry at gluing assembly | not a red flag — `homLocalSection` done; residual is mechanical but unaddressed |
| `dual_unit_iso` proof diverges from blueprint sketch (no left-unitor) | **minor** — mathematical content matches; sketch slightly stale |
| `lem:dual_unit_iso` proof block missing `\leanok` despite axiom-clean Lean | **minor** — sync_leanok should have caught this; chapter marker stale |

**Overall verdict**: Lean file is in good shape — no fake statements, no wrong signatures, no excuse-comments; the two open sorries are exactly at blueprint-identified frontiers. The chapter needs two targeted additions: a `\lean{homLocalSection}` tag (or dedicated block), and a concrete Lean-visible recipe for the HEq → IsCompatible bridge in the `homOfLocalCompat` proof sketch, to unblock the remaining sorry. 7 declarations checked, 0 critical red flags, 2 major blueprint-side gaps.
