# blueprint-clean bc258 — Report

## Chapter 1: `Picard_SheafOverEquivalence.tex` (NEW this iter)

### Checks passed
- `% archon:covers AlgebraicJacobian/Picard/SheafOverEquivalence.lean` — present and well-formed at line 3.
- All four declaration blocks present: `def:sheafofmodules_over_equivalence`, `lem:sheafofmodules_restrict_over_iso`, `lem:sheafofmodules_unit_over_iso`, `lem:chart_over_iso`.
- `% SOURCE:` block is well-formed code-location provenance (Archon-original assembly of Mathlib primitives; explicitly states no external-literature verbatim quote is present).
- `\leanok`/`\mathlibok` markers: none present — not touched.

### Stripped

1. **`% STRATEGY NOTE.` comment block** (28 lines removed) — architectural/project-internal narrative: referenced "prover lanes" (i) and (ii), "GENUINELY DIFFER" all-caps, "The project already owns the FIXED-value-category cousin", "INAPPLICABLE here", "discharged for free by typeclass inference". All project-history context, not mathematics.

2. **"The project already records the relevant datum:"** → **"The declaration"** in the continuity paragraph of `def:sheafofmodules_over_equivalence` proof.  Also "The documented Mathlib TODO ... is thus already discharged for" → "The Mathlib TODO ... is discharged for".

3. **"This is the slice-site analogue of the project's existing `\mathtt{pullbackObjUnitToUnitIso}` pattern."** → **"This is the slice-site analogue of `\mathtt{pullbackObjUnitToUnitIso}`."** in the `lem:sheafofmodules_unit_over_iso` proof.

4. **Last paragraph of `lem:chart_over_iso` proof** — rewrote to remove:
   - "the categorical content elided in the chart-presentation sketch" → "addresses the site mismatch in"
   - "so that the coherence engine of … consumes it as a single application" → "for use in"
   - "the same over-equivalence root serves the dual lane" → "The over-equivalence … likewise underlies the internal-Hom theory"
   - "is wired through … once the equivalence is in place" → "passes through the same equivalence"

---

## Chapter 2: `Picard_TensorObjSubstrate.tex` (D3′ Sq2/Sq2b section only)

### Scope
Only the `% NOTE:` comment preceding `lem:pullback_tensor_map_basechange` and the proof's Sq2/Sq2b paragraphs were touched; the remainder of the chapter was left untouched.

### Stripped

1. **`% NOTE:` comment** — trimmed iteration-label noise:
   - "D3' is the SOLE genuinely-new sub-step of the loc-triv route" removed.
   - "GENERAL … for ANY" all-caps removed.
   - "pullbackTensorMap is NOT an adjunction transpose (it is a **hand-built** four-fold composite)" → "it is a four-fold composite".
   - "the unit-analog mate calculus … does NOT transfer; the genuine route is the four-square comp_delta build" → phrased as a mathematical fact ("the mate-calculus argument … does not apply directly; the genuine proof pastes four squares directly").

2. **"it is the hand-built four-fold composite above"** → **"it is the four-fold composite above"** — "hand-built" is informal.

3. **"and stalls"** removed from "leaves an un-evaluable transpose of a concrete composite and stalls" — Lean execution language. Replaced "The genuine route pastes" → "The proof instead pastes".

4. **"closes by \(\mathtt{rfl}\) (it is the project lemma \(\mathtt{toRingCatSheafHom\_comp\_hom\_reconcile}\))"** — two fixes:
   - "project lemma" → removed; phrased as "(see the lemma …)" context replaced by "is definitional (\(\mathtt{toRingCatSheafHom\_comp\_hom\_reconcile}\))".
   - Lean tactic `\mathtt{rfl}` removed from prose; "closes by \(\mathtt{rfl}\)" → "is definitional".

5. **"pinned ring map"** → **"ring map"** — "pinned" is project-specific jargon.

6. **"dissolves the three frictions of a scheme-level statement"** → **"offers three advantages over a scheme-level statement"** — "frictions" is informal.

7. **"monoidal-instance metavariables"** → **"monoidal instances"** — "metavariables" is Lean type-theory jargon.

8. **"the factorisation through a composite functor \((F := F \circ G)\)"** — Lean named-argument syntax `(F := …)` removed; → "the factorisation through a composite functor".

9. **"Sq2 fires definitionally rather than failing to apply under composition"** → **"the Sq2 ring-map reconciliation is definitional"** — "fires" is Lean language.

10. **"We note, to correct the record, that the observation in the paragraph above"** → **"The observation above"** — "correct the record" is project-history language.

11. **"It does not bind Sq2b"** → **"does not constrain Sq2b"** — "bind" is functional-programming jargon.

12. In the Sq2b paragraph, **"closes by \(\mathtt{rfl}\)"** (second occurrence, about `unitToPushforwardObjUnit_comp`) → **"holds definitionally"**.

---

## SOURCE quote validation
- `Picard_SheafOverEquivalence.tex`: one `% SOURCE:` block present, explicitly flagged as code-location provenance (not external-literature); no `% SOURCE QUOTE:` required or expected. ✓
- `Picard_TensorObjSubstrate.tex` D3′ section: no `% SOURCE:` blocks in the edited region; none required. ✓

## No issues found
- No `\leanok`/`\mathlibok` markers were added or removed.
- No `\uses{}`/`\label{}` cross-references were altered.
- LaTeX structure is intact in both files.
