import Iris.BI.Interface

namespace Iris.BI

-- entailment
macro:25 "⊢ " P:term:25 : term => `(`[iprop| emp] ⊢ `[iprop| $P])
macro:25 P:term:29 " ⊣⊢ " Q:term:29 : term => `(`[iprop| $P] ≡ `[iprop| $Q])

delab_rule BIBase.entails
  | `(BIBase.entails `[iprop| emp] $P) => do `(⊢ $(← unpackIprop P))

-- iff and wand iff
syntax:27 term:28 " ↔ " term:28 : term
syntax:27 term:28 " ∗-∗ " term:28 : term

def bi_iff      [BIBase PROP] (P Q : PROP) : PROP := `[iprop| (P → Q) ∧ (Q → P)]
def bi_wand_iff [BIBase PROP] (P Q : PROP) : PROP := `[iprop| (P -∗ Q) ∧ (Q -∗ P)]

macro_rules
  | `(`[iprop| $P ↔ $Q])   => `(bi_iff `[iprop| $P] `[iprop| $Q])
  | `(`[iprop| $P ∗-∗ $Q]) => `(bi_wand_iff `[iprop| $P] `[iprop| $Q])

unif_hint [BIBase PROP] (P Q : PROP) where
  |- `[iprop| P ↔ Q] ≟ `[iprop| (P → Q) ∧ (Q → P)]
unif_hint [BIBase PROP] (P Q : PROP) where
  |- `[iprop| P ∗-∗ Q] ≟ `[iprop| (P -∗ Q) ∧ (Q -∗ P)]

delab_rule bi_iff
  | `(bi_iff $P $Q) => do `(`[iprop| $(← unpackIprop P) ↔ $(← unpackIprop Q)])
delab_rule bi_wand_iff
  | `(bi_wand_iff $P $Q) => do `(`[iprop| $(← unpackIprop P) ∗-∗ $(← unpackIprop Q)])

-- affine and absorb
syntax:max "<affine> " term:40 : term
syntax:max "<absorb> " term:40 : term

def bi_affinely    [BIBase PROP] (P : PROP) : PROP := `[iprop| emp ∧ P]
def bi_absorbingly [BIBase PROP] (P : PROP) : PROP := `[iprop| True ∗ P]

macro_rules
  | `(`[iprop| <affine> $P]) => `(bi_affinely `[iprop| $P])
  | `(`[iprop| <absorb> $P]) => `(bi_absorbingly `[iprop| $P])

unif_hint [BIBase PROP] (P : PROP) where
  |- `[iprop| <affine> P] ≟ `[iprop| emp ∧ P]
unif_hint [BIBase PROP] (P : PROP) where
  |- `[iprop| <absorb> P] ≟ `[iprop| True ∗ P]

delab_rule bi_affinely
  | `(bi_affinely $P) => do `(`[iprop| <affine> $(← unpackIprop P)])
delab_rule bi_absorbingly
  | `(bi_absorbingly $P) => do `(`[iprop| <absorb> $(← unpackIprop P)])

-- intuitionistic
syntax:max "□ " term:40 : term

def bi_intuitionistically [BIBase PROP] (P : PROP) : PROP := `[iprop| <affine> <pers> P]

macro_rules
  | `(`[iprop| □ $P]) => `(bi_intuitionistically `[iprop| $P])

unif_hint [BIBase PROP] (P : PROP) where
  |- `[iprop| □ P] ≟ `[iprop| <affine> <pers> P]

delab_rule bi_intuitionistically
  | `(bi_intuitionistically $P) => do `(`[iprop| □ $(← unpackIprop P)])

-- conditional modalities
syntax:max "<pers>?"   term:max term:40 : term
syntax:max "<affine>?" term:max term:40 : term
syntax:max "<absorb>?" term:max term:40 : term
syntax:max "□?"        term:max term:40 : term

def bi_persistently_if       [BIBase PROP] (p : Bool) (P : PROP) : PROP := `[iprop| if p then <pers> P else P]
def bi_affinely_if           [BIBase PROP] (p : Bool) (P : PROP) : PROP := `[iprop| if p then <affine> P else P]
def bi_absorbingly_if        [BIBase PROP] (p : Bool) (P : PROP) : PROP := `[iprop| if p then <absorb> P else P]
def bi_intuitionistically_if [BIBase PROP] (p : Bool) (P : PROP) : PROP := `[iprop| if p then □ P else P]

macro_rules
  | `(`[iprop| <pers>?$p $P])   => `(bi_persistently_if $p `[iprop| $P])
  | `(`[iprop| <affine>?$p $P]) => `(bi_affinely_if $p `[iprop| $P])
  | `(`[iprop| <absorb>?$p $P]) => `(bi_absorbingly_if $p `[iprop| $P])
  | `(`[iprop| □?$p $P])        => `(bi_intuitionistically_if $p `[iprop| $P])

delab_rule bi_persistently_if
  | `(bi_persistently_if $p $P) => do `(`[iprop| <pers>?$p $(← unpackIprop P)])
delab_rule bi_affinely_if
  | `(bi_affinely_if $p $P) => do `(`[iprop| <affine>?$p $(← unpackIprop P)])
delab_rule bi_absorbingly_if
  | `(bi_absorbingly_if $p $P) => do `(`[iprop| <absorb>?$p $(← unpackIprop P)])
delab_rule bi_intuitionistically_if
  | `(bi_intuitionistically_if $p $P) => do `(`[iprop| □?$p $(← unpackIprop P)])

end Iris.BI
