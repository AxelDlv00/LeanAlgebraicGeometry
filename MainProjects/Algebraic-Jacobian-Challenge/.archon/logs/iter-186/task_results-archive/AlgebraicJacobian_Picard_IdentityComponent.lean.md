# AlgebraicJacobian/Picard/IdentityComponent.lean

## Lane summary — NEW Lane IdentityComponent (file-skeleton)

**Status entering**: file present on disk from an earlier mechanical scaffold;
mandate is the iter-185 file-skeleton lane (UNCLEAR; blueprint-reviewer
HARD GATE CLEARED for chapter `Picard_IdentityComponent.tex`).

**Status exiting**: **SUCCESS — file-skeleton in place axiom-clean.**
- 5 declarations present, matching the 5 `\lean{...}` pins of
  `Picard_IdentityComponent.tex` verbatim.
- 5 typed `sorry` bodies (the deliberate file-skeleton outcome; bodies
  are iter-186+ work per lane mandate).
- `lean_diagnostic_messages` reports `success: true`, `failed_dependencies: []`,
  only the 5 expected `declaration uses 'sorry'` warnings (L129/157/193/234/285).
- File wired into `AlgebraicJacobian.lean` (line 21).
- No `Picard.lean` re-export shim exists in the project, so no further wiring
  step is required by the lane directive.

**Helper budget**: 0/0 (no helpers introduced; mandate forbids body attempts).
**Sorry delta**: 0 → **+5 typed sorries** (deliberate scaffold; planned per
`PROGRESS.md` "Sorry projection iter-185" line item).

## Per-declaration verification

All five `\lean{...}` pins in the chapter resolve to a `noncomputable def`
or `theorem` in `IdentityComponent.lean` with a substantive,
non-tautological type:

1. **`AlgebraicGeometry.GroupScheme.IdentityComponent`** (L129) —
   blueprint `def:identity_component_group_scheme`. Type:
   `Over (Spec (.of k))` (a `k`-scheme — non-tautological, not `G` itself).
   Hypotheses `[GrpObj _G] [LocallyOfFiniteType _G.hom]` match Kleiman §5
   `lem:agps`.
2. **`AlgebraicGeometry.GroupScheme.IdentityComponent.isOpenSubgroupScheme`**
   (L157) — blueprint `thm:identity_component_open_subgroup`. Type:
   `Nonempty {f : IdentityComponent G ⟶ G //
       IsOpenImmersion f.left ∧ IsClosedImmersion f.left}` — asserts the
   existence of a clopen-subscheme inclusion (not vacuous; the conjunct
   is a genuine structural property).
3. **`AlgebraicGeometry.Scheme.Pic0Scheme`** (L193) — blueprint
   `def:pic_zero_subscheme`. Type: `Over (Spec (.of k))`. Specialisation
   target — body will unwind to
   `GroupScheme.IdentityComponent (PicScheme C)` once the
   `[LocallyOfFiniteType (PicScheme C).hom]` instance lands.
4. **`AlgebraicGeometry.Scheme.PicScheme.degree`** (L234) — blueprint
   `def:divisor_degree_pic`. Type: `(Spec (.of k) ⟶ (PicScheme C).left) → ℤ`
   (a genuine function on `k`-points, not a constant).
5. **`AlgebraicGeometry.Scheme.Pic0Scheme.isAbelianVariety`** (L285) —
   blueprint `thm:pic_zero_is_abelian_variety`. Type:
   `IsProper (Pic0Scheme C).hom ∧ Smooth (Pic0Scheme C).hom ∧
    GeometricallyIrreducible (Pic0Scheme C).hom ∧
    Nonempty (GrpObj (Pic0Scheme C))`. The four-conjunct bundle of
   abelian-variety properties; each conjunct is a genuine
   property/structure on the typed-sorry `Pic0Scheme C`.

## Typeclass / Mathlib hover checks

Hover-resolved the key Mathlib identifiers used in the signatures (all
present in the project's Mathlib b80f227 toolchain):

- `CategoryTheory.GrpObj` — `Mathlib.CategoryTheory.Monoidal.Grp_`
- `AlgebraicGeometry.LocallyOfFiniteType` — `Mathlib.AlgebraicGeometry.Morphisms.FiniteType`
- `AlgebraicGeometry.IsProper` — `Mathlib.AlgebraicGeometry.Morphisms.Proper`
- `AlgebraicGeometry.Smooth` — `Mathlib.AlgebraicGeometry.Morphisms.Smooth`
- `AlgebraicGeometry.SmoothOfRelativeDimension` — `Mathlib.AlgebraicGeometry.Morphisms.Smooth`
- `AlgebraicGeometry.GeometricallyIntegral` — `Mathlib.AlgebraicGeometry.Geometrically.Integral`
- `AlgebraicGeometry.GeometricallyIrreducible` — `Mathlib.AlgebraicGeometry.Geometrically.Irreducible`

All signatures elaborate cleanly under the `import Mathlib +
AlgebraicJacobian.Picard.FGAPicRepresentability + AlgebraicJacobian.Genus`
chain.

## `\leanok` flagging (review-agent reads this section)

Five blueprint environments are ready for `\leanok` on the **statement
block** (signature present, typed `sorry` body):

- `def:identity_component_group_scheme` → `\leanok` on the `\begin{definition}`.
- `thm:identity_component_open_subgroup` → `\leanok` on the `\begin{theorem}`.
- `def:pic_zero_subscheme` → `\leanok` on the `\begin{definition}`.
- `def:divisor_degree_pic` → `\leanok` on the `\begin{definition}`.
- `thm:pic_zero_is_abelian_variety` → `\leanok` on the `\begin{theorem}`.

**No `\leanok` on any `\begin{proof}` block** — bodies are all `sorry`.
(Per project convention, `\leanok` is auto-managed by `sync_leanok`; I am
only noting which environments should pass that gate.)

## Iter-186+ body roadmap (per chapter prose + lane directive)

For the next agent picking up body work:

1. **`IdentityComponent` body** — construct as the open subscheme of `G`
   whose underlying topological space is the connected component of `|G|`
   at the image of `e : Spec k → G`. Uses
   `ConnectedComponents.mk` on `|G|`, EGA I 6.1.9 (locally Noetherian
   ⟹ open connected components), and the open-subscheme structure.
   Likely requires a Mathlib infra check for `Scheme.openSubscheme` of a
   `Set` carrier characterised by a connectedness predicate.
2. **`isOpenSubgroupScheme` body** — assemble from the open-subscheme
   structure of step 1 + "closure of a connected subspace is connected"
   for the closed-immersion conjunct.
3. **`Pic0Scheme` body** — unfolds to
   `GroupScheme.IdentityComponent (PicScheme C)` once a
   `[LocallyOfFiniteType (PicScheme C).hom]` instance is in place
   (instance follows from Kleiman §4 structure; project-side helper
   `Picard/FGAPicRepresentability.lean` likely needs the instance
   exported).
4. **`degree` body** — extract representing invertible sheaf from
   `PicScheme.representable C`, form its Hilbert polynomial via the
   `Picard/QuotScheme.lean` Hilbert-polynomial machinery (when Lane F /
   QuotScheme body work lands), return the leading coefficient.
5. **`isAbelianVariety` body** — assemble the 4 conjuncts from
   - `GroupScheme.IdentityComponent.isOpenSubgroupScheme` (clopen
     subscheme),
   - Kleiman §5 `th:qpp&p` (projective + geom. integral ⟹
     `Pic0` quasi-projective; geom. normal ⟹ projective),
   - Kleiman §5 `cor:sm` + `ex:jac` (smoothness at identity for smooth
     proper curves ⟹ smooth everywhere of dimension `g`).

The chapter prose proof (L147-L184 + L377-L437) is the authoritative
reference and is fully written; no blueprint expansion is needed for the
body work.

## Attempts log

### `AlgebraicGeometry.GroupScheme.IdentityComponent` (line 129) and the other 4 declarations
- **Approach**: per Lane directive, scaffold typed `sorry` bodies only;
  do NOT attempt bodies.
- **Result**: SCAFFOLD COMPLETE — pre-existing file matches the directive
  exactly. Verified each declaration's signature against the chapter's
  `\lean{...}` pin (all 5 match verbatim). Verified compile-clean via
  `lean_diagnostic_messages` (only the 5 expected typed-sorry warnings).
- **No body work** — explicit directive: "Forbidden: attempting to fill
  any body. This is mechanical scaffolding only. Bodies are iter-186+ work."

## Prover-stage re-verification (iter-185)

A subsequent prover-stage invocation re-ran `lean_diagnostic_messages` on
`AlgebraicJacobian/Picard/IdentityComponent.lean`: result unchanged —
`success: true`, `failed_dependencies: []`, exactly the 5 expected
"declaration uses `sorry`" warnings at L129, L157, L193, L234, L285. No
edits made; the iter-185 file-skeleton mandate ("do NOT attempt to prove
anything yet; helper budget = 0") was respected. Local PROGRESS.md
directive overrides the global prover-prover "push through sorries"
guidance per the project priority rule.

The file is wired into `AlgebraicJacobian.lean:21`; no `AlgebraicJacobian/Picard.lean`
re-export shim exists in the project tree, so the directive's optional
"Wire into …shim if one exists" clause was a no-op.

## Dead-end warnings / hazards for next iter

- The directive's example signature for declaration #2 in
  `objectives.md` (`identityComponent_open_subgroup`) does NOT match
  the chapter's `\lean{...}` pin
  (`IdentityComponent.isOpenSubgroupScheme`). The **chapter is
  authoritative** per project convention, so the file follows the
  chapter naming. If a future planner re-derives names from the
  objectives file rather than the chapter, this divergence will reappear.
- The `IdentityComponent` def takes its `G` parameter as `_G` (leading
  underscore) because the body is `sorry` and Lean would otherwise warn
  about an unused binder. When the body is filled in iter-186+, rename
  `_G` to `G`.
- `Pic0Scheme.isAbelianVariety` uses `Nonempty (GrpObj (Pic0Scheme C))`
  rather than the prescribed `[GrpObj A]` instance hypothesis pattern,
  because we cannot derive a `GrpObj` instance on a typed-sorry def.
  When the body lands, the conclusion likely upgrades to a `GrpObj`
  *instance* (or the consumer adjusts to consume the bundled
  `Nonempty`).
