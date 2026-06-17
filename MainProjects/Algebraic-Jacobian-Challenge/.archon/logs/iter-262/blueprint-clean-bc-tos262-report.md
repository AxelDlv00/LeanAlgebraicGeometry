# blueprint-clean bc-tos262 — report

**Status:** PASS — both sketches cleaned, no math content lost, no markers touched.

---

## Changes made

### 1. `lem:slice_dual_transport` proof

**Edit A — opening paragraph:**  
Removed the clause "; the bare structure-literal re-synthesis on the
`pushforward_0`-reduced carrier does not recover these instances, so both module structures
are supplied by hand." (Lean implementation detail). Reworded the opening to state
the module structures are identified explicitly, without naming the cause.

**Edit B — leg (A) description:**  
Replaced the parenthetical "not as a hand-built `ModuleCat.ofHom` ... a raw `ofHom` reduces
the carrier ... destroys the `restrictScalars`/`pushforward_0` module instance ...
This replaces the `eqToHom`-conjugation idiom used for thin-poset-only data" (Lean-tactic
leakage) with one short sentence: "a genuine change-of-rings functor acts here, so the map
is applied categorically via `.map`."

**Edit C — leg (B) description:**  
Stripped the "Two points make this go through cleanly" sub-paragraphs:
- Removed the `ConcreteCategory.bijective_of_isIso` tool call detail ("feeding g to the project
  lemma ... with bijectivity supplied by ...")
- Removed the `CommRing`-instance-native / `forget_2`-composite carrier paragraph (typeclass detail)
- Removed the "canonical monoidal unit vs presheaf-section spellings are definitional equality"
  paragraph (typeclass/defeq detail)

Retained: core statement that `ε` is invertible because `g` is a ring iso, citing
`restrictScalars_isIso_ε_of_bijective`, plus the `dualUnitIsoGen` reference.

**Edit D — inverse/naturality paragraph:**  
Replaced "`Iso.inv_hom_id` / `hom_inv_id` of `f.appIso` together with" (specific Lean lemma
names) by "the iso axioms of `f.appIso` together with."

---

### 2. `lem:dual_restrict_iso` proof — "Concretely" paragraph

**Edit E:**  
Replaced the Lean-tactic and project-history leakage:
- "The functorial `.map` is load-bearing: a map hand-built on underlying functions
  (`ModuleCat.ofHom`) would reduce the carrier and lose the `restrictScalars`/`pushforward_0`
  module instance, so leg (A) is built categorically rather than by the `eqToHom`-conjugation
  idiom used for thin-poset-only data."
- "Leg (B) is now **unblocked**" (project-history language)
- "worked at the `CommRingCat` level, so the `CommRing` instance is native, with the unit
  endpoints reconciled by definitional equality"

with neutral timeless prose: "Leg (A) is built categorically via
`(restrictScalars β_W).map`: a genuine change-of-rings functor acts here, so the reindexing
must be applied as a functor map rather than pointwise. Leg (B)'s unit comparison `ε` is
invertible because `β_W` is a ring isomorphism, as detailed in `lem:slice_dual_transport`."

---

### 3. `lem:pullback_tensor_map_basechange` proof

**Edit F — Sq2 reconciliation paragraph:**  
Removed the sentence listing Lean atoms not needed: "No pseudofunctor-coherence transport and
none of the associativity/unit bookkeeping atoms `PresheafOfModules.{pullbackId,
pullback_assoc, pullback_comp_id, pullback_id_comp}` are required for this reconciliation."
(implementation-level note).

**Edit G — Sq2b "Two points" — first point:**  
Changed "are all carried out, and together they discharge every part of Sq2b **except** the
single residual" (project-status past tense) to "together reduce Sq2b to the single residual".
Changed "First, the mate-calculus reduction **itself** is complete:" to "First, the
mate-calculus reduction proceeds as follows:".

**Edit H — Sq2b "Two points" — second point:**  
Removed "No `extendScalarsComp` / `restrictScalarsComp` change-of-rings build enters
anywhere." (Lean name detail). Replaced "With this residual closed, Sq2b ... is fully
discharged." (project-history past tense) with "This closes the Sq2b obligation."

**Edit I — Sq2b presheaf-level paragraph:**  
Removed the "three advantages" enumeration which included: "`forget_2` monoidal instances
are fixed by `φ'`" (typeclass detail) and "comes for free from the `pullbackComp` signature"
(informal). Replaced with a single-sentence statement that at the presheaf level "the
composite factorisation is immediate from `pullbackComp` and the ring-map reconciliation is
definitional."

**Edit J — summary paragraph:**  
Replaced project-progress phrasing:
- "extracted with a partial mate-calculus proof" → removed
- "is fully discharged" → "follows from the mate-calculus reduction above"
- "is proved" → "follows from the same identification"  
- "carries no proof obligation" → removed (definitional = no obligation is clear from context)
- "Sq1 is the immediate target --- closing it yields a measurable reduction and unlocks Sq4" →
  replaced with "Sq4 reduces to Sq1 via the `pullbackValIso` factorisation, so Sq1 is the open
  target"

---

## Unchanged

- All `\lean{}`, `\uses{}`, `\label{}` entries: intact
- All `% archon:covers` lines (file top, lines 3–6): intact
- All `\leanok` markers: not added or removed
- `% SOURCE`/`% SOURCE QUOTE` blocks on `lem:dual_restrict_iso`: intact
- All blocks outside the two named sketches: untouched
- No reference-retriever spawned (no missing citation found on active-prover-lane blocks)
