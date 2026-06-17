# Lean ↔ Blueprint Check Report

## Slug
fga-iter199

## Iteration
199

## Files audited
- Lean: `AlgebraicJacobian/Picard/FGAPicRepresentability.lean`
- Blueprint: `blueprint/src/chapters/Picard_FGAPicRepresentability.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.PicScheme.abelMap}` (chapter: lem:line_bundle_quot_correspondence)

- **Lean target exists**: yes (L281)
- **Signature matches**: yes — `divFunctor C ⟶ picSharp C` faithfully encodes
  blueprint's `A_{C/k} : Div_{C/k} → Pic^♯_{(C/k)ét}` as a natural transformation
  of presheaves on `(Sch/k)^op`
- **Proof follows sketch**: N/A — body is carrier extraction
  `Classical.choice (HasAbelMap.has_abel_map)`, not a direct proof; sorry lives in
  `instHasAbelMap` (L294, `⟨sorry⟩`)
- **notes**: Blueprint carries `\leanok` on the lemma statement block (expected under
  carrier-soundness probe; sorry isolated in instance). The carrier typing is correct.

---

### `\lean{AlgebraicGeometry.Scheme.PicScheme.smoothProperQuotient}` (chapter: lem:smooth_proper_quotient)

- **Lean target exists**: yes (L377 — blueprint's location paragraph still says L354;
  stale after iter-199 refactor)
- **Signature matches**: partial. Hypotheses (i)–(iv) of Kleiman §4 Lem. `lm:qt` are
  all present: `Z.RepresentableBy Y` (quasi-projective Z), `(Limits.pullback α
  α).RepresentableBy R` (R representable), `[Smooth π.left] [IsProper π.left]` (first
  projection smooth + proper), and the surjection lift property. Conclusion is
  `P.IsRepresentable`. The blueprint additionally states "α is representable by a
  smooth map" as a secondary conclusion (Kleiman `lm:qt` last sentence) — this
  secondary conclusion is absent from the Lean type. **Pre-existing gap, not
  introduced in iter-199.**
- **Proof follows sketch**: partial in a specific sense. The theorem body is now
  axiom-clean (iter-199 refactor): `HasSmoothProperQuotient.is_representable (_α := α)`.
  The mathematical content of the proof sketch (EGA IV 8.11.5 + Altman–Kleiman descent)
  lives in the `instHasSmoothProperQuotient` instance body as `⟨sorry⟩`. Blueprint's
  proof block has `\leanok`, which is correct at the theorem-body level but note the
  instance carrying the mathematical obligation is sorry-filled.
- **notes**: The blueprint does NOT describe the iter-199 refactor in the Sorry 4
  subsection — see **Red flags** below for full analysis.

---

### `\lean{AlgebraicGeometry.Scheme.PicScheme.representable}` (chapter: thm:fga_pic_representability)

- **Lean target exists**: yes (L433)
- **Signature matches**: yes — `(picSharp C).RepresentableBy (PicScheme C)` precisely
  encodes the blueprint's "picSharp C is representable by PicScheme C"
- **Proof follows sketch**: N/A — body is `Classical.choice
  (PicSharpRepresentable.has_representable)`, sorry in `instPicSharpRepresentable` (L446)
- **notes**: `\leanok` on statement block, no proof-block `\leanok` (expected, carrier
  soundness). Signature clean.

---

### `\lean{AlgebraicGeometry.Scheme.PicScheme.groupSchemeStructure}` (chapter: thm:pic_is_group_scheme)

- **Lean target exists**: yes (L489, `noncomputable instance`)
- **Signature matches**: yes — `GrpObj (PicScheme C)` matches blueprint's
  "PicScheme C is a GrpObj (group-object) structure"
- **Proof follows sketch**: N/A — body is `Classical.choice
  (PicSchemeGroupObject.has_group_object)`, sorry in `instPicSchemeGroupObject` (L502)
- **notes**: `\leanok` on theorem block. Blueprint reference `\cref{def:rel_pic_sharp}`
  in the source comment of thm:pic_is_group_scheme is the iter-199 fix applied
  (previously `\cref{df:Pfs}`); fix is correct.

---

### `\lean{AlgebraicGeometry.Scheme.PicScheme}` (chapter: def:pic_scheme)

- **Lean target exists**: yes (L223, `noncomputable def PicScheme`)
- **Signature matches**: yes — `Over (Spec (.of k))` (a k-scheme) encoding of the
  Picard scheme matches the blueprint definition; extracted from `HasPicScheme.has_pic_scheme`
- **Proof follows sketch**: N/A (definition, not theorem)
- **notes**: `\leanok` on definition block. Carrier typed correctly.

---

## Red flags

### Blueprint: Stale description of Sorry 4 location (major)

**Finding 1 — Location paragraph of `\subsec:sorry_smooth_proper_quotient` (L779–784):**

Blueprint currently says:

> "line~354; the only free `sorry` in the file (i.e.\ not inside an instance
> constructor). It is the proof body of theorem
> `AlgebraicGeometry.Scheme.PicScheme.smoothProperQuotient`, whose conclusion type is
> `P.IsRepresentable`."

Post iter-199 actual state:
- There is **no free sorry in the theorem body**. The theorem body is axiom-clean,
  calling `HasSmoothProperQuotient.is_representable (_α := α)`.
- The sorry (sole new `⟨sorry⟩`) lives in `instance instHasSmoothProperQuotient` at
  **L349** — inside an instance constructor, not a "free sorry" in the proof sense.
- The theorem declaration now begins at **L377** (not L354).
- The claim "the only free sorry in the file (i.e. not inside an instance constructor)"
  is **false** after iter-199: all 7 sorries are now `⟨sorry⟩` inside instance bodies.

This is a stale location description introduced by the iter-199 refactor but not updated
in the blueprint's Sorry 4 subsection. The mathematical content description (Altman–Kleiman
+ EGA IV 8.11.5) is still accurate; only the implementation site is wrong.

**Finding 2 — Closure-order section intro (`\sec:fga_pic_sorry_closure_order`, L579–581):**

Blueprint currently says:

> "carries seven open sorries, namely one free `sorry` inside the proof of the
> smooth-proper quotient lemma and six `⟨sorry⟩` instance bodies for the **six**
> carrier typeclasses `HasPicSharp`, `HasDivFunctor`, `HasPicScheme`, `HasAbelMap`,
> `PicSharpRepresentable`, `PicSchemeGroupObject`."

Post iter-199 actual state:
- ALL seven sorries are `⟨sorry⟩` instance bodies — there is no free sorry in any
  proof body.
- There are now **seven** carrier typeclasses (the six listed plus
  `HasSmoothProperQuotient` added in iter-199).
- The list of six typeclasses is missing `HasSmoothProperQuotient`.

**Finding 3 — Closure-order summary (`\subsec:fga_pic_closure_order_summary`, L1052–1059):**

Blueprint currently says:

> "Sorry~4 (the `smoothProperQuotient` free `sorry`) is the highest-value rank-2 target:
> ... **it removes the only non-instance sorry from the file**."

Post iter-199 actual state:
- Sorry 4 was already "moved to an instance" by the iter-199 refactor. There is no
  longer a non-instance sorry to remove by closing Sorry 4.
- The stated motivation ("removes the only non-instance sorry from the file") is now
  inoperative. Sorry 4's Rank-2 priority rationale (structural lemma, no sibling-chapter
  gate, bounded EGA IV 8.11.5 sub-task) remains valid, but not via this argument.

### Missing `instHasSmoothProperQuotient` in sorry closure documentation (minor)

The new typeclass `HasSmoothProperQuotient` (L338–341) and its instance
`instHasSmoothProperQuotient` (L346–349) are introduced in iter-199 but appear nowhere
in the blueprint's `\sec:fga_pic_sorry_closure_order`. All six older carrier instances
are named in the intro list (L580–581). The seventh is absent.

This is a documentation gap: the sorry closure subsection for Sorry 4 should at minimum
state "sorry now in `instHasSmoothProperQuotient`" and update the instance count.

### Missing secondary conclusion in `smoothProperQuotient` Lean type (minor, pre-existing)

The Lean conclusion of `smoothProperQuotient` is `P.IsRepresentable`. The blueprint's
`lem:smooth_proper_quotient` statement (and the Kleiman source `lm:qt`) additionally
asserts "α is representable by a smooth map." This secondary conclusion is absent from
the Lean type. Pre-existing across iterations; not introduced in iter-199. Noted for
completeness but not blocking.

---

## Unreferenced declarations (informational)

The following Lean declarations have no `\lean{...}` pin in the blueprint. All are
carrier-soundness probe substrate — none are substantive in the blueprint-level sense:

| Declaration | Line | Status |
|---|---|---|
| `class HasPicSharp` | 127 | carrier helper; named in Sorry 1 subsection |
| `def picSharp` | 139 | file-internal placeholder; documented in §0 |
| `instance instHasPicSharp` | 147 | sorry site; named in Sorry 1 subsection |
| `class HasDivFunctor` | 154 | carrier helper; named in Sorry 2 subsection |
| `def divFunctor` | 167 | file-internal placeholder; documented in §0 |
| `instance instHasDivFunctor` | 174 | sorry site; named in Sorry 2 subsection |
| `class HasPicScheme` | 199 | carrier helper; named in Sorry 5 subsection |
| `instance instHasPicScheme` | 232 | sorry site; named in Sorry 5 subsection |
| `class HasAbelMap` | 261 | carrier helper; named in Sorry 3 subsection |
| `instance instHasAbelMap` | 290 | sorry site; named in Sorry 3 subsection |
| `class HasSmoothProperQuotient` | 338 | **NEW iter-199** — NOT named in Sorry 4 subsection |
| `instance instHasSmoothProperQuotient` | 346 | **NEW iter-199** — NOT named in Sorry 4 subsection |
| `class PicSharpRepresentable` | 409 | carrier helper; named in Sorry 6 subsection |
| `instance instPicSharpRepresentable` | 442 | sorry site; named in Sorry 6 subsection |
| `class PicSchemeGroupObject` | 465 | carrier helper; named in Sorry 7 subsection |
| `instance instPicSchemeGroupObject` | 498 | sorry site; named in Sorry 7 subsection |

No carrier helper is pin-worthy as a standalone `\lean{...}` block. The issue is that
`HasSmoothProperQuotient` and `instHasSmoothProperQuotient` should appear in the Sorry 4
subsection text (not as a `\lean{...}` block) in parallel with how the other six
instances appear in their respective sorry subsections.

---

## Blueprint adequacy for this file

- **Coverage**: 5/5 blueprint-pinned Lean declarations have a corresponding `\lean{...}`
  block in the chapter. All 16 unreferenced declarations are carrier/helper substrate —
  none are substantive orphans.
- **Proof-sketch depth**: adequate for the pinned declarations. The Sorry 4 proof sketch
  (EGA IV 8.11.5 + Altman–Kleiman descent) is mathematically complete and still accurate.
  The closure recipe sections for Sorries 1–3 and 5–7 are unchanged and accurate.
- **Hint precision**: precise. All 5 `\lean{...}` pins name the correct Lean declarations
  with correct namespacing (`AlgebraicGeometry.Scheme.PicScheme.*`). No stale pins.
- **Generality**: matches need. Carrier-soundness probe pattern is correctly described and
  motivated for all 7 sorry sites.
- **Recommended chapter-side actions (for blueprint-writing subagent):**
  1. **Update `\subsec:sorry_smooth_proper_quotient` Location paragraph** (L779–784):
     Replace "line~354; the only free `sorry` in the file (i.e.\ not inside an instance
     constructor). It is the proof body of theorem..." with: "line~349; the `⟨sorry⟩`
     body of instance `instHasSmoothProperQuotient` (class `HasSmoothProperQuotient`,
     L338). The theorem body of `smoothProperQuotient` (L377) is now **axiom-clean**
     (iter-199 carrier-soundness refactor), calling
     `HasSmoothProperQuotient.is_representable` to extract the conclusion from the
     typeclass field."
  2. **Update `\sec:fga_pic_sorry_closure_order` intro** (L579–581): Change "one free
     `sorry` inside the proof of the smooth-proper quotient lemma and six `⟨sorry⟩`
     instance bodies for the **six** carrier typeclasses `HasPicSharp`, `HasDivFunctor`,
     `HasPicScheme`, `HasAbelMap`, `PicSharpRepresentable`, `PicSchemeGroupObject`" to:
     "seven `⟨sorry⟩` instance bodies for the seven carrier typeclasses: `HasPicSharp`,
     `HasDivFunctor`, `HasPicScheme`, `HasAbelMap`, `HasSmoothProperQuotient`,
     `PicSharpRepresentable`, `PicSchemeGroupObject`. The theorem body of
     `smoothProperQuotient` is now axiom-clean (iter-199)."
  3. **Update closure-order summary** (L1052–1059): The motivation "removes the only
     non-instance sorry from the file" for prioritizing Sorry 4 is now wrong. Replace
     with the accurate motivation: the structural lemma is the highest-value rank-2
     target because it is independently closeable without sibling-chapter gates, and the
     EGA IV 8.11.5 sub-task is bounded.

---

## Severity summary

| # | Finding | Severity |
|---|---|---|
| 1 | Sorry 4 subsection (`subsec:sorry_smooth_proper_quotient`) location paragraph still describes pre-iter-199 state: says sorry is "free sorry in proof body at L354" — actual location is `⟨sorry⟩` in `instHasSmoothProperQuotient` at L349, theorem body is now axiom-clean | **major** |
| 2 | Closure-order intro (`sec:fga_pic_sorry_closure_order`) says "one free sorry ... and six `⟨sorry⟩` instance bodies for the six carrier typeclasses" — after iter-199 all 7 are instance bodies and the new `HasSmoothProperQuotient` typeclass is unlisted | **major** |
| 3 | Closure-order summary motivation "removes the only non-instance sorry from the file" for prioritizing Sorry 4 is now inoperative (no non-instance sorry remains after iter-199) | **major** |
| 4 | `HasSmoothProperQuotient` / `instHasSmoothProperQuotient` (new iter-199) not mentioned in the Sorry 4 subsection text; all other carrier instances are named in their respective sorry subsections | **minor** |
| 5 | `smoothProperQuotient` Lean type lacks secondary conclusion "α is representable by a smooth map" (present in both Kleiman `lm:qt` and blueprint statement); pre-existing gap, not iter-199 | **minor** |

**No must-fix-this-iter findings.** All five `\lean{...}` pins are accurate. Lean
declaration signatures match the blueprint statements. The carrier-soundness probe
pattern (sorry isolated in typeclass instance bodies, theorem bodies axiom-clean) is
correctly implemented for all 7 sorry sites. The blueprint stale state is in the
sorry-closure documentation section only, not in any `\lean{...}`-pinned block.

**Overall verdict**: 5 declarations checked, 5 pins accurate — the blueprint's sorry
closure section carries 3 major stale descriptions of the iter-199 carrier-soundness
refactor (Sorry 4 now lives in `instHasSmoothProperQuotient`, not in the theorem body)
that should be updated by a blueprint-writing dispatch.
